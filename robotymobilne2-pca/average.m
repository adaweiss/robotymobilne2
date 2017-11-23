function [ wynik ] = average( wektor, okno )
%AVERAGE Oblicza i zwraca uœredniony wektor.
%   Funkcja zwraca uœreniony wektor wejœciowy. Okno okreœla rozmiar wektora
%   wartoœci 1/okno, który jest splatany z wektorem wejœciowym.

wynik=conv(wektor,ones(1,okno)/okno','same');

end

