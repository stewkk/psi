program list(input, output);
uses System.IO, System.Text;

const Year='1954'; Drive='F:';

var s : string[180];
   s1 : string[180];
   s2 : string[180];
   f, g, o : text;
   i, i2, k, ns : integer;
    nR, nE : integer; { }
        QV : integer; { BDRip or TVRip or WEB-DL в первой строке }
       lan : array [1..10] of string[2]; { языки в строке  - xx - unknown }
     Trans : string[12];
         T : integer;

function digit(x: char): Boolean;
begin
  if (x >= '0') and ('9' >= x) then digit := True else digit := False;
end;

function letter(x: char): Boolean;
begin
  letter:= False;
  if (x >= 'А') and ('Я' >= x) then letter := True;
  if (x >= 'а') and ('я' >= x) then letter := True;
end;

function check_sym(x: char): Boolean;
var i: integer;
begin
  check_sym := False;
  for i := 1 to length(s) do if s[i] = x then begin check_sym := True; i2:=i end
end;

function check_slash_n : Integer;
var i, n: integer;
begin
  n := 0;
  for i := 1 to length(s) do if s[i] = '/' then n:=n+1;
  check_slash_n := n
end;

procedure FirstLineQV;
begin
      QV:=Pos('BDRip', s);
      if QV=0 then QV:=Pos('TVRip', s);
      if QV=0 then QV:=Pos('WEB-DL', s);
      if QV=0 then QV:=Pos('DVDRip', s);
      if QV<>0 then Delete(s, QV, length(s) - QV);
end;

function Pattern (t : string; var i,j : integer): Boolean;
var ok : Boolean;
begin
  reset(g);
  ok:=False;
  repeat
    readln(g, s);
    if Pos(t, s) <> 0 then ok:=True;
  until eof(g) or ok;
  if ok then begin i:=Pos(':', s) + 1;
                   {j:=Pos('/', s); if j<>0 then j:=j - 1 else}
                   j:=length(s);
             end;
  Pattern:=ok;
end;

procedure Perewod;
var ok : Boolean;
     i : integer;
begin
  reset(g); ok:=False; Trans:='';
  repeat
    readln(g, s);
    if Pos('Перевод:', s) <> 0 then
               begin ok:=True;
                 if Pos('Профессиональный (дублированный', s) <> 0 then Trans:=Trans+'+pd';
                 if Pos('Профессиональный дублированный', s) <> 0 then Trans:=Trans+'+pd';
                 if Pos('(полное дублирование)', s) <> 0 then Trans:=Trans+'+pd';
                 if Pos('Дублированный [лицензия]', s) <> 0 then Trans:=Trans+'+dl';
                 if Pos('Дублированный', s) <> 0 then Trans:=Trans+'+pd';
                 if Pos('дубляж', s) <> 0 then Trans:=Trans+'+pd';
                 if Pos('Много', s) <> 0 then Trans:=Trans+'+pmz';
                 if Pos('много', s) <> 0 then Trans:=Trans+'+pmz';
                 if Pos('Профессиональный одноголосый', s) <> 0 then Trans:=Trans+'+p1';
                 if Pos('Профессиональный (двухголосый закадровый)', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Профессиональный (двуголосый закадровый)', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Профессиональный дву', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Двуголосый закадровый, профессиональный', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Двухголосый закадровый, профессиональный', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Двуголосый закадровый, любительский', s) <> 0 then Trans:=Trans+'+L2';
                 if Pos('Двуголосый закадровый, авторский', s) <> 0 then Trans:=Trans+'+p2';
                 if Pos('Любительский много', s) <> 0 then Trans:=Trans+'+Lmz';
                 if Pos('Любительский двухголосый', s) <> 0 then Trans:=Trans+'+L2';
                 if Pos('Любительский (двухголосый', s) <> 0 then Trans:=Trans+'+L2';
                 if Pos('Любительский одноголосый', s) <> 0 then Trans:=Trans+'+L1';
                 if Pos('Одноголосый закадровый, любительский', s) <> 0 then Trans:=Trans+'+L1';
                 if Pos('Любительский (одноголосый', s) <> 0 then Trans:=Trans+'+L1';
                 if Pos('Любительское (одноголосый', s) <> 0 then Trans:=Trans+'+L1';
                 if Pos('Авторский', s) <> 0 then Trans:=Trans+'+a1';
                 if Pos('авторский', s) <> 0 then Trans:=Trans+'+a1';
                 if Trans = '' then begin
                    if Pos('Двуголосый закадровый', s) <> 0 then Trans:=Trans+'+?2';
                    if Pos('Двухголосый закадровый', s) <> 0 then Trans:=Trans+'+?2';
                    if Pos('Одноголосый закадровый', s) <> 0 then Trans:=Trans+'+?1';
                    if Pos('Одноголосный, закадровый', s) <> 0 then Trans:=Trans+'+?1';
                 end;
               end;
  until eof(g) or ok;
  if Trans <> '' then
       begin
       for i:=1 to Length(Trans)-1 do Trans[i]:=Trans[i+1];
       Trans[Length(Trans)]:=' ';
       end;
end;

procedure Cadr;
var     ok : Boolean;
 i, nH, nV : integer;
      H, V : array [1..4] of char;
begin
  reset(g); ok:=False;
  repeat
    readln(g, s);
    i:=Pos('Размер кадра:', s);
    if i <> 0 then i:=i + 12 else
      begin i:=Pos('Видео:', s);
        if i <> 0 then i:=i + 5 else
          begin i:=Pos('Видеокодек: MPEG-4 AVC/H.264,', s);
            if i <> 0 then i:=i + 28;
          end;
      end;
    if i <> 0 then
      repeat
          repeat i:=i + 1 until digit(s[i]);
          { dddd x ddd or ddd x ddd or dddd x dddd }
          nH:=1;
          while digit(s[i]) and (nH<5) do begin H[nH]:=s[i]; i:=i + 1; nH:=nH + 1 end;
          if nH<=5 then begin
            if (s[i]=' ') and (s[i+1]='x') then ok:=True;
            if (s[i]='x') then ok:=True;

            if (s[i]=' ') and (s[i+1]='х') then ok:=True;
            if (s[i]='х') then ok:=True;

            if ok then begin
              nV:=1;
              repeat i:=i + 1 until digit(s[i]);
              while digit(s[i])and (nV<5) do begin V[nV]:=s[i]; i:=i + 1; nV:=nV+1 end;
            end;
          end;
      until ok;
      if ok then begin
      for i:=1 to nH - 1 do write(o, H[i]); write(o, ' x ');
      for i:=1 to nV - 1 do write(o, V[i]);
      end;
  until eof(g) or ok;
end;

procedure Quality;
var ok : Boolean;
     i : integer;
begin
  reset(g); ok:=False;
  repeat
    readln(g, s);
    i:=Pos('Качество видео:', s);
    if i <> 0 then i:=i + 15 else
      begin
        i:=Pos('Качество:', s);
        if i <> 0 then i:=i + 9;
      end;
    if i <> 0 then
      begin
        ok:=True;
        repeat  i:=i + 1; write(o, s[i]);
        until (i=length(s)) OR (s[i]=' ');
      end;
  until eof(g) or ok;
end;

procedure Duration;
var ok : Boolean;
     i, j : integer;
begin
  reset(g); ok:=False; T:=0;
  repeat
    readln(g, s);
    j:=Pos(':', s);
    i:=Pos('Продолжительность:', s);
    if i=0 then i:=Pos('Длительность:', s);
    if i <> 0 then
      begin i:=i + j; T:=0;
         repeat i:=i + 1 until (s[i]='0') or (s[i]='1');
         if s[i]='0' then i:=i + 1;
         T:=60 * (ord(s[i])- ord('0')); i:=i + 2;
         T:=T + 10 * (ord(s[i])- ord('0')) + (ord(s[i+1])- ord('0'));
         ok:=True;
      end;
  until eof(g) or ok;
end;

procedure Genre;
var ok : Boolean;
     i : integer;
begin
  reset(g); ok:=False;
  repeat
    readln(g, s);
    i:=Pos('Жанр:', s);
    if i <> 0 then
      begin i:=i + 6;
         repeat
           s[i]:=UpCase(s[i]);
           repeat write(o, s[i]); i:=i+1 until (s[i]=',') or (i=Length(s));
           if i=Length(s) then begin ok:=True; write(o, s[i]) end;
           if s[i]=',' then begin write(o, ' / '); i:=i+2 end;
         until ok;
      end;
  until eof(g) or ok;
end;

procedure FormCont;
var
     i, j, k : integer;
      fnames : array of string;
begin
  fnames := Directory.GetFiles('.'); k:=0;
  repeat
    i:=Pos('.jpg', fnames[k]);
    if i = 0 then
      begin i:=Pos('.png', fnames[k]);
        if i = 0 then
      begin i:=Pos('.srt', fnames[k]);
        if i = 0 then
      begin i:=Pos('.mka', fnames[k]);
        if i = 0 then
      begin i:=Pos('.txt', fnames[k]);
        if i = 0 then
      begin i:=Pos('.ac3', fnames[k]);
        if i = 0 then
      begin i:=Pos('.dts', fnames[k]);
        if i = 0 then
          begin i:=Pos('.', fnames[k]);
            if i <> 0 then begin
                             for j:=length(fnames[k]) - 2 to length(fnames[k]) do
                                 write(o, fnames[k][j]);
                           end;
          end;
      end;
      end;
      end;
      end;
      end;
      end;
    k:=k+1;
  until k=length(fnames);
end;

function Check_Languages : integer;
var j : integer;
begin lan[1]:='  '; j:=0;
  if (Pos('Рус', s)<>0) or (Pos('рус', s)<>0) or (Pos('Rus', s)<>0) or (Pos('rus', s)<>0) then begin j:=j+1; lan[j]:='ru' end;
  if (Pos('Анг', s)<>0) or (Pos('анг', s)<>0) or (Pos('Eng', s)<>0) or (Pos('eng', s)<>0) then begin j:=j+1; lan[j]:='en' end;
  if (Pos('нем', s)<>0) or (Pos('Нем', s)<>0)             then begin j:=j+1; lan[j]:='de' end;
  if (Pos('Ger', s)<>0) or (Pos('ger', s)<>0)             then begin j:=j+1; lan[j]:='de' end;
  if (Pos('Spanish', s)<>0) or (Pos('Исп', s)<>0) or (Pos('исп', s)<>0) then begin j:=j+1; lan[j]:='es' end;
  if (Pos('Espan', s)<>0) or (Pos('espan', s)<>0)         then begin j:=j+1; lan[j]:='es' end;
  if (Pos('Персид', s)<>0) or (Pos('персид', s)<>0)       then begin j:=j+1; lan[j]:='pe' end;
  if (Pos('Порту', s)<>0) or (Pos('порту', s)<>0)         then begin j:=j+1; lan[j]:='po' end;
  if (Pos('Portu', s)<>0) or (Pos('portu', s)<>0)         then begin j:=j+1; lan[j]:='po' end;
  if (Pos('Польск', s)<>0) or (Pos('польск', s)<>0)       then begin j:=j+1; lan[j]:='pl' end;
  if (Pos('Сербский', s)<>0) or (Pos('сербский', s)<>0)   then begin j:=j+1; lan[j]:='se' end;
  if (Pos('Украин', s)<>0) or (Pos('украин', s)<>0)       then begin j:=j+1; lan[j]:='ua' end;
  if (Pos('Турецкий', s)<>0) or (Pos('турецкий', s)<>0)   then begin j:=j+1; lan[j]:='tu' end;
  if (Pos('Иврит', s)<>0) or (Pos('иврит', s)<>0)         then begin j:=j+1; lan[j]:='iv' end;
  if (Pos('Итальянск', s)<>0) or (Pos('итальянск', s)<>0) then begin j:=j+1; lan[j]:='it' end;
  if (Pos('Italian', s)<>0) or (Pos('italian', s)<>0)     then begin j:=j+1; lan[j]:='it' end;
  if (Pos('Исланд', s)<>0) or (Pos('исланд', s)<>0)       then begin j:=j+1; lan[j]:='is' end;
  if (Pos('Француз', s)<>0) or (Pos('француз', s)<>0) or (Pos('French', s)<>0) then begin j:=j+1; lan[j]:='fr' end;
  if (Pos('Датский', s)<>0) or (Pos('датский', s)<>0)                          then begin j:=j+1; lan[j]:='da' end;
  if (Pos('Нидерландск', s)<>0) or (Pos('нидерландск', s)<>0)                  then begin j:=j+1; lan[j]:='du' end;
  if (Pos('Norwegian', s)<>0) or (Pos('norwegian', s)<>0)                      then begin j:=j+1; lan[j]:='no' end;
  if (Pos('Норве', s)<>0) or (Pos('норве', s)<>0)                              then begin j:=j+1; lan[j]:='no' end;
  if (Pos('китайск', s)<>0) or (Pos('Китайск', s)<>0)                          then begin j:=j+1; lan[j]:='ch' end;
  if (Pos('кантон', s)<>0) or (Pos('Кантон', s)<>0)                          then begin j:=j+1; lan[j]:='ka' end;
  if (Pos('мандарин', s)<>0) or (Pos('Мандарин', s)<>0)                      then begin j:=j+1; lan[j]:='ma' end;
  if (Pos('Тайск', s)<>0) or (Pos('тайский', s)<>0) then              begin j:=j+1; lan[j]:='ti' end;
  if (Pos('Японск', s)<>0) or (Pos('японск', s)<>0) then              begin j:=j+1; lan[j]:='jp' end;
  if (Pos('Japan', s)<>0) or (Pos('japan', s)<>0) then              begin j:=j+1; lan[j]:='jp' end;
  if (Pos('Korean', s)<>0) or (Pos('korean', s)<>0) then              begin j:=j+1; lan[j]:='ko' end;
  if (Pos('Корей', s)<>0) or (Pos('корей', s)<>0) then                begin j:=j+1; lan[j]:='ko' end;
  if (Pos('Румын', s)<>0) or (Pos('румын', s)<>0) then                begin j:=j+1; lan[j]:='ro' end;
  if (Pos('Венге', s)<>0) or (Pos('венге', s)<>0) then                begin j:=j+1; lan[j]:='hu' end;
  if (Pos('Болгар', s)<>0) or (Pos('болгар', s)<>0) then              begin j:=j+1; lan[j]:='bl' end;
  if (Pos('Филиппинск', s)<>0) or (Pos('филиппинск', s)<>0) then      begin j:=j+1; lan[j]:='fl' end;
  if (Pos('Финский', s)<>0) or (Pos('финский', s)<>0) then            begin j:=j+1; lan[j]:='fi' end;
  if (Pos('Чешск', s)<>0) or (Pos('чешск', s)<>0) then                begin j:=j+1; lan[j]:='cz' end;
  if (Pos('Шведский', s)<>0) or (Pos('шведский', s)<>0) then          begin j:=j+1; lan[j]:='sw' end;
  if (Pos('Эстонский', s)<>0) or (Pos('эстонский', s)<>0) then        begin j:=j+1; lan[j]:='et' end;
  if (Pos('Латышский', s)<>0) or (Pos('латышский', s)<>0) then        begin j:=j+1; lan[j]:='lt' end;
  if (Pos('Литовский', s)<>0) or (Pos('литовский', s)<>0) then                      begin j:=j+1; lan[j]:='li' end;
  Check_Languages := j;
end;
  {
    Аудио #1: Русский
    Аудио 1: Русский
    Аудио №1
  Аудио:
  1. AC3, 2 ch, 192 Кбит/с - русский
  2. AC3, 2 ch, 192 Кбит/с - немецкий
  Аудио:
  1. AC3, 6 ch, 384 Кбит/с - русский
  2. AC3, 6 ch, 384 Кбит/с - английский
    Аудио: 48 kHz, AAC, 2ch, 128 Kbps | Russian | Дублированный
    Аудио: 48 kHz, AAC, 2ch, 128 Kbps | English | Original
    Аудио: ... (Russian)
    Аудио: Русский
==============
  Аудио: Russian / English:
    Оригинальная аудиодорожка: нидерландский
  Аудио 1: Русский
  Аудио 2: Русский
  Аудио 3: Русский
  Аудио 3: Английский
  }

procedure Audio_Cont;
var  i, j, k, R, flagRU : integer;
           Lan2 : array [1..10] of string[2];
begin
  reset(g); j:=0;
  repeat
    readln(g, s);
    i:=Pos('Аудио:', s);
    if i <> 0 then begin k:=1; R:=Check_Languages;
      if R=1 then begin j:=j+1; Lan2[j]:=lan[1] end; { 1 строка - язык; j=1 }
      repeat
        readln(g, s); k:=k+1; R:=Check_Languages;
        if R=1 then begin j:=j+1; Lan2[j]:=lan[1] end; { в след.строке - язык }
{       if (R=0) and (k = 1) then begin j:=j+1; Lan2[j]:='xx' end;  }
{       if (R=0) and (j = 2) then begin j:=j+1; Lan2[j]:='xx' end;  }
      until (k>5) or eof(g);
    end else begin
               if (Pos('Аудио 1:', s)<>0)or(Pos('Аудио #1:', s)<>0)or(Pos('Аудио1:', s)<>0)or(Pos('Аудио №1', s)<>0)or(Pos('Аудио#1:', s)<>0) then
               begin k:=1; R:=Check_Languages;
                     if R=1 then begin j:=j+1; Lan2[j]:=lan[1] end;
                     if R=0 then begin j:=j+1; Lan2[j]:='xx' end;
                     repeat
                       readln(g, s); k:=k+1; R:=Check_Languages;
                       if (R=1) and (Pos('Аудио', s)<>0) then begin j:=j+1; Lan2[j]:=lan[1] end;
                       if (R=0) and (Pos('Аудио', s)<>0) then begin j:=j+1; Lan2[j]:='xx' end;
                     until (k>5) or eof(g);
               end;
             end;
    until eof(g);
  if j<>0 then begin k:=1; flagRU:=0;
                      repeat
                         if Lan2[k]='ru' then begin
                             if flagRU=0 then begin flagRU:=1; write(o, Lan2[k]); if k<>j then write(o, '/') end;
                             end else begin write(o, Lan2[k]); if k<>j then write(o, '/') end;
                        k:=k+1;
                      until k>j;
               end else write(o, 'ru');
end;

procedure Sub_Cont;
var ok, net : Boolean;
       k, R : integer;
begin
  reset(g);
  { Вид субтитров: Отсутствуют
    Субтитры: Отсутствуют
    Субтитры: нет
    Субтитры: Нет
    Язык субтитров: Отсутствуют
    Язык субтитров: Немецкий
    Язык субтитров: Русские ... английские
    Язык субтитров: Русский
    Язык субтитров: Русский, английский
    Язык субтитров: Английский
    Язык субтитров: Итальянские }
  repeat
    ok:=False;  net:=False;
    readln(g, s);
    if Pos('Вид субтитров: Отсутствуют', s) <> 0 then net:=True;
    if Pos('Субтитры: Отсутствуют', s)      <> 0 then net:=True;
    if Pos('Субтитры: Нет', s)              <> 0 then net:=True;
    if Pos('Субтитры: нет', s)              <> 0 then net:=True;
    if Pos('Язык субтитров: Отсутствуют', s)<> 0 then net:=True;
    if net then ok:=True
           else begin
                  if (Pos('Язык субтитров:', s)<>0) or (Pos('Cубтитры:', s)<>0) then begin
                                   R:=Check_Languages;
                                   if R<>0 then begin k:=1;
                                                  repeat write(o, Lan[k]);
                                                    if k<>R then write(o, '/');
                                                    k:=k+1;
                                                  until k>R;
                                                end
                                                   {else write(o, 'xx')};
                                   ok:=True;
                  end;
                end;
  until eof(g) or ok;
end;

function varYO (var i, j : integer): Boolean;
begin
  varYO:=True;
  if not Pattern('Режиссер:', nR, nE) then
    if not Pattern('Режиссёр:', nR, nE) then
      if not Pattern('Режиссеры:', nR, nE) then
        if not Pattern('Режиссёры:', nR, nE) then
          varYO:=False;
end;

procedure wr(var j, k : integer);
var i :integer;
begin
  for i:=j+1 to k do write(o, s[i]);
end;

begin
  ChDir(Drive); s1 := GetCurrentDir; writeln('*** ', s1);
  assign(f, 'dir'+Year+'.bat');          rewrite(f);
  write(f, 'dir /B '+Year+' >list.txt'); close(f);
  Execute('dir'+Year+'.bat'); Sleep(1000);    { в list.txt список всех файлов в Year }
  assign(f, 'list.txt'); reset(f);
  assign(o, 'tabl.txt'); rewrite(o);
  ChDir(Year);
  repeat
    readln(f, s2);
    ChDir(s2); writeln('***** ', s2);
    assign(g, 'info.txt'); reset(g);  { обработка файла info.txt  }
    readln(g, s);                     { FIRST line of info.txt - Title }
                                      { writeln(s);               }
                                      { H264:=Pos('H.264', s);    }
    FirstLineQV;                      { Качество видео из первой строки }
    i := 1;
    ns:=Check_Slash_n;
    if ns >= 1 then begin
      while s[i] <> '/' do i := i + 1;  { Title - второе название становится первым }
      nR := i - 1; {write(o, '\');}
      for k:=1 to ns-1 do begin i:=i+1; while s[i] <> '/' do i := i + 1 end;

      if check_sym('(') then
        begin i:=i2;
          while s[i] <> '(' do i := i + 1;
          nE := i - 1; { проблема с тем, что в кв.скобках }
        end
        else nE := length(s) + 1;
      for k := nR + 3 to nE - 1 do write(o, s[k]); write(o, ' / ');
      for k := 1 to nR do write(o, s[k]);
    end else Write('Place to kino');
    write(o, '\');
    Perewod;    write(o, Trans);                { "Перевод:" of info.txt }
    write(o, '\');
    { год }     write(o, Year);
    write(o, '\');
    { "Режиссер:" of info.txt }

    if varYO(nR, nE) then begin wr(nR, nE);
      { + "Страна:" of info.txt }{ or "Производство:" of info.txt }

      if Pattern('Производство:', nR, nE) then begin {!!!! ::::: !!!!!}
                  write(o, ' / '); wr(nR, nE);
                                          end;
      if Pattern('Прoизводство:', nR, nE) then begin {!!!! ::::: !!!!!}
                  write(o, ' / '); wr(nR, nE);
                                          end;
      if Pattern('Страна:', nR, nE) then begin
                  write(o, ' / '); wr(nR, nE);
                                          end;


    end;
    write(o, '\');
    write(o, 'hdd'+Year); write(o, '\');         { Place }
    Cadr; write(o, '\');                         { "Видео:" of info.txt }
    Quality; write(o, '\');                      { "Качество видео:" of info.txt }
    Duration;                                    { "Продолжительность:" of info.txt }
    if T<>0 then if T<100 then begin
                            Write(o, '0'); Write(o, T:2); Write(o, ' min')
                            end else begin
                            Write(o, T:3); Write(o, ' min')
                          end;
                write(o, '\');
    Genre;      write(o, '\\');                    { "Жанр:" of info.txt }
    FormCont;   write(o, '\');                     { "Формат:" of info.txt }
    Audio_Cont; write(o, '\');                        { "Аудио:" of info.txt }
    Sub_Cont;   writeln(o, '\');                      { "Субтитры:" of info.txt }
      { конец обработки - один фильм - одна строка для БД }
    close(g);
    ChDir('..');
  until eof(f);
  close(f);  close(o);
  writeln('OK')
end.
