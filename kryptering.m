clc
clear all
close all
% Lab 3
% 2017-12-02 Karl Hallberg
% (ditt datum ditt namn)

% Det som behövs göras som jag inte löste var att göra en pie() av de 10
% mest frekventa bokstäverna i text-filen, min funktion slutar efter att
% bokstäverna slutar vara jättefrekventa. Någon sorts funktion som räknar
% igenom alla elementen krävs och sedan göra ett diagram av det

% Läser in en krypterad fil och gör den till
% stora bokstäver samt konverterar dem till ASCII
fid = fopen('krypterad1.txt','rt');
textOriginal = fscanf(fid,'%c',Inf);
textUpper = upper(textOriginal);
textAsc = double(textUpper);
textTest = textAsc; % använder mig utav textTest för att kunna dekryptera från originaltext sedan

% Kom på att mellanslag är 32 i ASCII så tar bort
% dem från min array jag modifierar men den verkar EJ FUNGERA det verkar
% inte behövas men det kan komma upp som en frekvent bokstav i små texter
% så lär behöva fixa, find(textTest==0) = [] gissar jag skulle kunna
% fungera på ngt sätt

 i = 1;
 while i < length(textTest)
      if textTest(i) == 32
         textTest(i) = [];
     end
     i = i + 1;
 end
 
% Sorterar i storleksordning
textTest = sort(textTest);

% mode kollar det mest frekventa tecknet i arrayn och jag kollar
% efter det sedan tar jag bort den och alla andra förekomster från textTest
% för att kunna skaffa en samling av mest frekventa bokstäver
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

% för k från 1 till antal frekventa bokstäver jag samlade på mig så testar
% den från E som är 69 i ASCII, som är den mest frekventa bokstaven. Här
% samlar jag då ett gäng rullningar som jag sedan testar flera av, ifall E
% inte var det som förekom flest.
for k = 1:length(throw)
    throw(k) = (throw(k) - 69);
end

% skapar bara en vektor med alla rullningar som heter rullning, onödig
% egentligen
rullning = [];
for k = 1:length(throw)
    rullning = [rullning throw(k)];
end

% skapar en matris med nollor som har lika många rader som rullningar, så
% att jag kan testa flera olika rullningar i samma matris sedan men på
% separata rader, längd av hela texten också
dek = zeros(length(rullning), length(textAsc));

% huvud-loopen håller på tills jag har slut på rullningar att försöka men
% loopen inuti kör hela texten, där den då byter ut ASCII i originaltexten
% mot ASCII ifrån mina rullningar, if-else och det är för att de rullar
% över från Z till B t.ex. och hade fått en ASCII som ej stämde, alfabetet
% går från A=65 till Z=90
i = 1;
while i <= length(rullning)
    for k = 1:length(textAsc)
        if textAsc(k)>64 && textAsc(k)<91%rullar bara om värdet motsvarar en versal bokstav.
                                          %vet inte hur jag ska få radbryten att fungera
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

disp(char(dek))

