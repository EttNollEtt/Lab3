clc
clear all
close all
% Lab 3
% 2017-12-02 Karl Hallberg
% 2017-12-09 Kevin Kihlström

% Läser in en krypterad fil och gör den till
% stora bokstäver samt konverterar dem till ASCII

fid = fopen('krypterad3.txt','rt');
textOriginal = fscanf(fid,'%c',Inf);
textUpper = upper(textOriginal);
textAsc = double(textUpper);
textTest = textAsc;    % använder mig utav textTest för att kunna dekryptera från originaltext sedan
textTestPaj = textAsc; % skapar en ny för att underlätta
textTest = textTest(find(textTest~=32));
textTest = sort(textTest);

% samlar de mest frekventa bokstäverna m.h.a mode
% hade kunnat lägga in om antal , i = -antal
throw = [];
i = 1;
while i < length(textTest) % den fortsätter tills det är bara bokstäver som förekommer lika många ggr eller väldigt få jag vet inte riktigt
    M = mode(textTest);    % vilket var smidigt för mig för då har jag bara väldigt frekventa
    if textTest(i) == M
        textTest(textTest==M) = []; % söker alla förekomster av den mest frekventa och tar bort dem
        throw = [throw M]; % lägger in dem i en egen array och använder nu längre inte textTest
    end
    i = i + 1;
end

% här samlar jag då ett gäng rullningar som jag sedan testar flera av, ifall E
% inte var den som förekom flest ggr i texten.
for k = 1:length(throw)
    throw(k) = (throw(k) - 69);
end

rullning = [];
for k = 1:length(throw)
    rullning = [rullning throw(k)];
end

% skapar en matris med nollor som har lika många rader som antal rullningar
% pre-allocation FTW
dek = zeros(length(rullning), length(textAsc));

% huvud-loopen håller på tills jag har slut på rullningar att försöka men
% loopen inuti kör hela texten, där den då byter ut ASCII i originaltexten
% mot ASCII ifrån mina rullningar, if-else och det är för att de rullar
% över från Z till B t.ex. och hade fått en ASCII som ej stämde.
i = 1;
while i <= length(rullning)
    for k = 1:length(textAsc)
        if textAsc(k)>64 && textAsc(k)<91%rullar bara om värdet motsvarar en versal bokstav.
          dek(i,k) = textAsc(k) - rullning(i); % rullar bak k:te elementet på den raden som stämmer med den specifika rullningen
          if dek(i,k) <= 64
              dek(i,k) = dek(i,k) + 26;
          elseif dek(i,k) > 90
              dek(i,k) = dek(i,k) - 26;
          elseif dek(i,k) == 32
              dek(i,k) = 32;
          end
        end
    end
    i = i + 1;
end

textTestPaj = textTestPaj(find(textTestPaj~=32));

throw=[];
for k = 1:10 %hittar de 10 vanligaste
    M = mode(textTestPaj);
    antal = length(textTestPaj==M); %antalet av bokstäverna liggs till i throw
    for i = 1:antal
        throw = [throw M];
    end
    textTestPaj(textTestPaj==M) = []; %tar bort bokstaven som den lade in i throw
end

for k = 1:10
    M = mode(throw); %tar den vanligaste bokstaven i throw
    namn(k) = M; %lägger till den i namn som ASCII
    L = length(throw==M); %antalet av bokstaven
    delar(k) = L ; %denna ger proportionerna på diagrammet
    throw(throw==M) = []; %tar bort fråm throw
    labels{1,k} = char(namn(k)); %lägger in bokstäverna i en cell arrray
end

pie(delar, labels)
disp(char(dek))
