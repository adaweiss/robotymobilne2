clear all;

pers_no=1;
EMG = 1;               % czy używać EMG do badań
MMG = 0;               % czy używać MMG do badań
fs=1000;               % częstotliwość próbkowania
% USTAWIENIA - ONSET
czy_onset = 1;         % czy używać onset
okno_onset = 13;       % szerokość okna uśredniającego wektor
prog_onset = 0.76;     % próg (mnoży się przez niego wartość średnią z modułu kanału) wykrywania początku
dlug_wek_onset = 1400;  % długość jaka ma być uzyskana po obcięciu wektora 2000 próbek czasowych przez funkcję onset
% USTAWIENIA - KLASYFIKACJA
ile_proc_uczy = 50;         % iloma procentami powtórzeń należy uczyć klasyfikator
k = 1;                      % ile sąsiadów brać pod uwagę
metryka='cityblock';        % typ metryki
% USTAIWENIA - PCA
red = 60;              %wymiar zredukowanych cech


filename=sprintf('osoba_%d.mat',pers_no);
variable=sprintf('osoba_%d',pers_no);

if exist(filename, 'file') == 0
    % Import danych z Bazy %%%%%%%%%%%%%%%%%%%%%%
    for mov_no=1:11 %ilośc ruchów
        path=sprintf('../Baza16kan/osoba_%d/ruch_%d',pers_no,mov_no);

        d = dir(sprintf('%s/*.txt',path));
        files = {d.name};

        for i=1:length(files)
            str = sprintf('%s/%s',path,files{i});
            read_file(str,pers_no,mov_no,i);
        end
    end
    save(filename, variable);
    clear d i nazwa_ruchu files path str mov_no filename variable
else
    load(filename);
end

% ONSET
if czy_onset
    dane=eval(sprintf('osoba_%d',pers_no));
    wynik=onset( dane,dlug_wek_onset,okno_onset,prog_onset);
    size_wynik=size(wynik);
    eval(sprintf('osoba_%d_1_onset=wynik;',pers_no));
    clear dane wynik czy_onset dlug_wek_onset okno_onset prog_onset
else
    eval(sprintf('osoba_%d_1_onset=osoba_%d;',pers_no,pers_no));
    clear czy_onset dlug_wek_onset okno_onset prog_onset
end

% EKSTRAKCJA CECH - STFT
dane=eval(sprintf('osoba_%d_1_onset',pers_no));
if (EMG==1)
    EMGspectr=spectr_matrix_1mod(dane,1,fs);    % tworzy spektrogramy dla EMG
end

if (MMG==1)
    MMGspectr=spectr_matrix_1mod(dane,2,fs);    % tworzy spektrogramy dla MMG   
end

% SELEKCJA - PCA
EMGnowe = reshape(EMGspectr, size(EMGspectr,1)*size(EMGspectr,2), size(EMGspectr,3));
[coeff, score, V] = pca(EMGnowe);
[coeff2, signal] = PCA(EMGnowe');

sred = mean(EMGnowe);
EMGcentr = EMGnowe - repmat(sred,size(EMGspectr,1)*size(EMGspectr,2),1);

Z=coeff(:,1:red)'*EMGcentr';
Z = Z';
Z = reshape(Z, size(EMGspectr,1),size(EMGspectr,2),red);

PCAAA=zeros(1,8);
for i=1:8
    suma=0;
    for j=1:25
        for a=1:red
            suma=suma+abs(coeff((i-1)*25+j,a));
        end
    end
    PCAAA(i)=suma;
end

figure;
stem(1:8,PCAAA);

dane=Z(:,:,:);

% KLASYFIKACJA
ile_trenuje=size(dane,2)*ile_proc_uczy/100 ;                % oblicza ile powtórzeń ma trenować klasyfikator
ile_testuje=size(dane,2)-ile_trenuje ;                      % oblicza ile powtórzeń ma testować klasyfikator
permutacja=randperm(size(dane,2)) ;                         % losuje kolejność powtórzeń
ind_train=sort(permutacja(1:ile_trenuje));                  % wybiera odpowiednią ilość pierwszych losowych powtórzeń do treningu
ind_test=sort(permutacja(ile_trenuje+1:size(dane,2))) ;     % wybiera pozostałe do testu

train=reshape(permute(dane(:,ind_train,:),[2 1 3]),[size(dane,1)*ile_trenuje,size(dane,3)]);    % tworzy macierz trenujących powtórzeń
test=reshape(permute(dane(:,ind_test,:),[2 1 3]),[size(dane,1)*ile_testuje,size(dane,3)]);      % tworzy macierz testujących powtórzeń

nazwy=zeros(size(dane,1)*ile_trenuje,1);
for mov_no=1:size(dane,1)
   %nazwy((1:ile_trenuje)+(mov_no-1)*ile_trenuje)=(mov_no)*1000+ind_train;	% w nazwie uwzględnia się nr powtórzenia
   nazwy((1:ile_trenuje)+(mov_no-1)*ile_trenuje)=mov_no;                 	% nazwa to tylko nr klasy
end

mdl = fitcknn(train,nazwy); % tworzy model klasyfikatora
mdl.NumNeighbors=k;
mdl.Distance=metryka;
wynik=predict(mdl,test);    % uruchamia klasyfikacje

truthtable=zeros(size(dane,1));

for mov_no=1:size(dane,1)   % tworzy truthtable
    rozp_klasy=unique(wynik((1:ile_testuje)+(mov_no-1)*ile_testuje));
    ilosci_rozp_klas=histc(wynik((1:ile_testuje)+(mov_no-1)*ile_testuje),rozp_klasy);
    truthtable(mov_no,rozp_klasy)=ilosci_rozp_klas;
end
srednia = (trace(truthtable)/(size(dane,1)*ile_testuje))*100
eval(sprintf('osoba_%d_9_truthtable=truthtable;',pers_no));
