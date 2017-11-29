function [ mat_spectr ] = spectr_matrix_1mod(dane, first_chan, fs)
%SPECTR_MATRIX_1MOD_TESTY Wylicza macierze spektrogramowe danej modalno�ci
%   first_chan okre�la, czy obliczamy EMG (first_chan=1), czy MMG (first_chan=2)

%mat_spectr=zeros(size(dane,1),size(dane,2),3200);
%spect_vec=zeros(1,3200);
czy_usredniac=1;
ile_f=5;
ile_f_odrzucic=0;
ile_t=5;
ile_t_odrzucic=0;
S_nowe=zeros(ile_f,ile_t);
spect_vec=[];
for mov_no=1:size(dane,1)%dla każdego ruchu
    mov_no
    for rep_no=1:size(dane,2) %dla każdego powtórzenia
        for chan_no=first_chan:2:size(dane,3) %EMG czy MMG
            tmp=squeeze(dane(mov_no,rep_no,chan_no,:));%wyciąga cały wektor dla iteratorów
            %tworzy spektrogram przy pomoty fouriera(dane, window,noverlap,nfft)
            S=spectrogram(tmp,128,30,128,fs);% Dla 1800 ustawić noverlap na 40, �api� si� wszystkie. dla 2000 ustawi� 30, �apie si� 1990.
            if czy_usredniac
                S_odrzucone=S(1:size(S,1)-ile_f_odrzucic,1:size(S,2)-ile_t_odrzucic);
                for f=1:ile_f
                    for t=1:ile_t
                        m = round((f-1)*size(S_odrzucone,1)/ile_f+1);
                        n = round((f-1)*size(S_odrzucone,1)/ile_f+size(S_odrzucone,1)/ile_f);
                        v = round((t-1)*size(S_odrzucone,2)/ile_t+1);
                        z = round((t-1)*size(S_odrzucone,2)/ile_t+size(S_odrzucone,2)/ile_t);
                        S_nowe(f,t)=mean(mean(abs(S_odrzucone(m:n ,v:z))));
                    end
                end
                spect_vec=[spect_vec abs(S_nowe(:))'];
            else
                spect_vec=[spect_vec abs(S(:))'];
            end
        end
        mat_spectr(mov_no,rep_no,:)=spect_vec(:);
        spect_vec=[];
    end
end

end