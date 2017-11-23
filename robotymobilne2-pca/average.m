function [ wynik ] = average( wektor, okno )
%AVERAGE Oblicza i zwraca u�redniony wektor.
%   Funkcja zwraca u�reniony wektor wej�ciowy. Okno okre�la rozmiar wektora
%   warto�ci 1/okno, kt�ry jest splatany z wektorem wej�ciowym.

wynik=conv(wektor,ones(1,okno)/okno','same');

end

