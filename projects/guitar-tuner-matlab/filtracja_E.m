function y = filtracja_E(x)

persistent Hd;

if isempty(Hd)
    
    Fstop1 = 10;     % First Stopband Frequency
    Fpass1 = 60;     % First Passband Frequency
    Fpass2 = 120;    % Second Passband Frequency
    Fstop2 = 3000;   % Second Stopband Frequency
    Astop1 = 60;     % First Stopband Attenuation (dB)
    Apass  = 1;      % Passband Ripple (dB)
    Astop2 = 60;     % Second Stopband Attenuation (dB)
    Fs     = 44100;  % Sampling Frequency
    
    h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
        Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
    
    Hd = design(h, 'equiripple', ...
        'MinOrder', 'any');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);

