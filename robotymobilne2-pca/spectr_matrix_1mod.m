function [ mat_spectr ] = spectr_matrix_1mod(dane, first_chan, fs)
%SPECTR_MATRIX_1MOD_TESTY Wylicza macierze spektrogramowe danej modalnoœci
%   first_chan okreœla, czy obliczamy EMG (first_chan=1), czy MMG (first_chan=2)

%mat_spectr=zeros(size(dane,1),size(dane,2),3200);
%spect_vec=zeros(1,3200);
czy_usredniac=1;
ile_f=5;
ile_f_odrzucic=0;
ile_t=5;
ile_t_odrzucic=0;
S_nowe=zeros(ile_f,ile_t);
size_dane_spec = size(dane)
spect_vec=[];
for mov_no=1:size(dane,1)%dla ka¿dego ruchu
    mov_no
    for rep_no=1:size(dane,2)%dla ka¿dego powtórzenia
        for chan_no=first_chan:2:16%EMG czy MMG
            tmp=squeeze(dane(mov_no,rep_no,chan_no,:));%wyci¹ga ca³y wektor dla iteratorów
            size_tmp=size(tmp)
            
            %tworzy spektrogram przy pomoty fouriera(dane, window,noverlap,nfft)
            S=spectrogram(tmp,128,30,128,fs);% Dla 1800 ustawiæ noverlap na 40, ³api¹ siê wszystkie. dla 2000 ustawiæ 30, ³apie siê 1990.
            size(S)
            if czy_usredniac
                S_odrzucone=S(1:size(S,1)-ile_f_odrzucic,1:size(S,2)-ile_t_odrzucic);
                for f=1:ile_f
                    for t=1:ile_t
                        m = (f-1)*size(S_odrzucone,1)/ile_f+1;
                        n = (f-1)*size(S_odrzucone,1)/ile_f+size(S_odrzucone,1)/ile_f;
                        v = (t-1)*size(S_odrzucone,2)/ile_t+1;
                        z = (t-1)*size(S_odrzucone,2)/ile_t+size(S_odrzucone,2)/ile_t;
                        S_nowe(f,t)=mean(mean(abs(S_odrzucone(m:n ,v:z))));
                        
                    end
                end
                spect_vec=[spect_vec abs(S_nowe(:))'];
                cos_Dziwnego = size(spect_vec)
            else
                spect_vec=[spect_vec abs(S(:))'];
            end
        end
        mat_spectr(mov_no,rep_no,:)=spect_vec(:);
        spect_vec=[];
    end
end
if czy_usredniac
    clf
    size_S = size(S);
    size_Snowe = size(S_nowe)
    subplot(1,2,1);
    bar3(abs(S));
    subplot(1,2,2);
    bar3(S_nowe);
    xlabel('t');
    ylabel('f');
    zlabel('s');
else
    clf;
    sizeS = size(S);
    bar3(abs(S));
end
end