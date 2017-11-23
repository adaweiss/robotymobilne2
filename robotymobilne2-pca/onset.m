function [ wynik ] = onset( dane, dlugosc, okno, prog)
%ONSET Zwraca zmodyfikowan� baz� jednej osoby
%   Znajduje pocz�tek sygnalu (w sensie przekroczenia sygna�u u�rednionego
%   jego �redniej pomno�onej przez prog) oraz wycina jego fragment tak, by
%   zosta�o 'dlugosc' pr�bek. Je�eli punkt rozpocz�cia znajduje si� dalej ni�
%   'size(dane,4)-dlugosc' lub je�eli nie zostanie znaleziony w og�le,
%   przyjmujemy start jako 'size(dane,4)-dlugosc'.

wynik=zeros(size(dane,1),size(dane,2),size(dane,3),dlugosc);
poczatki=zeros(1,size(dane,3));

for mov_no=1:size(dane,1)
    for rep_no=1:size(dane,2)
        for chan_no=1:size(dane,3)
            
            data=abs(squeeze(dane(mov_no,rep_no,chan_no,:)))';
            wart_sr=mean(data);    % wylicza warto�� �redni� z modu�u do u�ywania w progowaniu
            tmp=average(data,okno);
            chan_start=find(tmp>wart_sr*prog,1);
            
            if isempty(chan_start)
                chan_start=length(data)-dlugosc;
            end
            poczatki(chan_no)=chan_start;
        end
        start=min(max(floor(median(poczatki)),1),length(data)-dlugosc);
        wynik(mov_no,rep_no,:,:)=dane(mov_no,rep_no,:,start:start+dlugosc-1);
    end
end
end