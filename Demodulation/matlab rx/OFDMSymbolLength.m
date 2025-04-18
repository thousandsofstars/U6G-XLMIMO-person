
function [Lsym, Lu, Lcp] = OFDMSymbolLength(Nfft)
    %function [Lsym, Lu, Lcp] = OFDMSymbolLength(Nfft)
    %   Returns the number of time domain samples, Lsym, in each
    %   OFDM symbol of the SS block. The useful part, Lu, and
    %   cyclic prefix length, Lcp, can also be returned
    %   optionally.
    
    Lu   = Nfft;
    Lcp  = 144 * Nfft/2048;
    Lsym = Lcp + Lu;
    
end