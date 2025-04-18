
function ssBlockGrid = ofdmDemodulateSSBlock(inputSignal,ssBlockStartOffset)
    %OFDM demodulate the SS block and return the 240 x 4 resource grid.
    
    [Lsym, Lfft, Lcp] = OFDMSymbolLength(256);
    NgridSize         = 240;
    
    % Determine time domain indices of ss block.
    ssBlockIndices = (1:4*Lsym)+ssBlockStartOffset;
    
    % Extract SS block samples and remove cyclic prefix.
    ssBlock   = inputSignal(ssBlockIndices);
    ssSymbols = reshape(ssBlock,Lsym,4);
    fftInput  = ssSymbols(Lcp+1:Lsym,:);
    
    % FFT. Divide output by sqrt(Lfft) to preserve the energy
    % between time and frequency domain samples.
    fftOutput = fftshift(fft(fftInput)/sqrt(Lfft),1);
    
    % Remove unused bins.
    kStart      = (Lfft - NgridSize)/2;
    ssBlockGrid = fftOutput( kStart+1 : end-kStart, : );
    
end