pers_no=2;
for mov_no=1:11
    path=sprintf('../Baza16kan/osoba_%d/ruch_%d',pers_no,mov_no);
    
    d = dir(sprintf('%s/*.txt',path));
    files = {d.name};
    
    for i=1:length(files)
        str = sprintf('%s/%s',path,files{i});
        read_file(str,pers_no,mov_no,i);
    end
end

filename=sprintf('osoba_%d.mat',pers_no);
variable=sprintf('osoba_%d',pers_no);

if exist(filename, 'file') == 0
    save(filename, variable);
end

clear i nazwa_ruchu path str pers_no mov_no filename variable


