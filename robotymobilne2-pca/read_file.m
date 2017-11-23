function [ ] = read_file( file_dir, pers_no, mov_no, repeat )
%READ_FILE Funkcja wczytuje pojedynczy plik powt_*.txt do odpowiedniej
%zmiennej
%   Funkcja sprawdza, czy zmienna o nazwie 'osoba_<pers_no>' istnieje w przestrzeni
%   roboczej. Tworzy lub modyfikuje plik, dodaj¹c odpowiednie ruchy.

var_name=sprintf('osoba_%d',pers_no);

if (evalin('base',sprintf('exist(''%s'')',var_name))==1);
    tmp=evalin('base',var_name);
end

src_file=load(file_dir);
for i=1:16
    tmp(mov_no,repeat,i,:)=src_file(:,i);
end
assignin('base', var_name, tmp);
end