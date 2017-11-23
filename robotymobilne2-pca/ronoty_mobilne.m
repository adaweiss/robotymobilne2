close all;
clear all;

pers_no=1;
EMG = 1;               % czy u¿ywaæ EMG do badañ
MMG = 0;               % czy u¿ywaæ MMG do badañ
fs=1000;               % czêstotliwoœæ próbkowania
% USTAWIENIA - ONSET
czy_onset = 1;         % czy u¿ywaæ onset
okno_onset = 13;       % szerokoœæ okna uœredniaj¹cego wektor
prog_onset = 0.76;     % próg (mno¿y siê przez niego wartoœæ œredni¹ z modu³u kana³u) wykrywania pocz¹tku
dlug_wek_onset = 900;  % d³ugoœæ jaka ma byæ uzyskana po obciêciu wektora 2000 próbek czasowych przez funkcjê onset

% Import danych z Bazy %%%%%%%%%%%%%%%%%%%%%%
for mov_no=1:11 %iloœc ruchów
    path=sprintf('../Baza16kan/osoba_%d/ruch_%d',pers_no,mov_no);
    
    d = dir(sprintf('%s/*.txt',path));
    files = {d.name};
    
    for i=1:length(files)
        str = sprintf('%s/%s',path,files{i});
        read_file(str,pers_no,mov_no,i);
    end
end
clear d i nazwa_ruchu files path str mov_no

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
%zwraca macierz [no_ruchu][no_powtorzenia][jakiœ splot kana³u i odczytu]?
dane=eval(sprintf('osoba_%d_1_onset',pers_no));
size_dane=size(dane)
if (EMG==1)
    EMGspectr=spectr_matrix_1mod(dane,1,fs);    % tworzy spektrogramy dla EMG
    size_EMGspec=size(EMGspectr)
    %bar3_stacked(EMGspectr);
    
    figure(3)
    hold on; grid on;
    for k=1:10
    temp = squeeze(EMGspectr(k,:,:));
   % bar3(temp);
    PC = abs(PCA(abs(temp)'));
    PC2 = pca(abs(temp),'Algorithm','eig')
    PCAA=PC(:,1)+PC(:,2)+PC(:,3)
    
    for i=0:7
        suma=0;
        for j=1:25
            suma=suma+PCAA(i*25+j)
        end
        PCAAA(i+1)=suma;
    end
   subplot(5,2,k)
   stem([1:8], PCAAA); hold on;
    end 
end

if (MMG==1)
    MMGspectr=spectr_matrix_1mod(dane,2,fs);    % tworzy spektrogramy dla MMG
    size_MMGspec=size(MMGspectr);    
    figure(3)
    hold on; grid on;
    for j = 1:1:size_MMGspec(2)
        temp = squeeze(MMGspectr(:,j,:))
        bar3(temp);
    end
end







