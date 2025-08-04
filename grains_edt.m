% Copyright 2025 National Technology & Engineering Solutions of Sandia, LLC (NTESS). Under the terms of Contract DE-NA0003525 with NTESS, the U.S. Government retains certain rights in this software.

% Copyright 2025 National Technology & Engineering Solutions of Sandia, LLC (NTESS)

% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

% 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function grains_edt(pname, file)
    close all;
    % crystal symmetry
    CS = {... 
        'notIndexed',...
        crystalSymmetry('6/mmm', [3 3 4.7], 'X||a*', 'Y||b', 'Z||c*', 'mineral', 'Ti-Hex', 'color', [0.53 0.81 0.98]),...
        crystalSymmetry('4/mmm', [5.8 5.8 3.2], 'mineral', 'Tin beta', 'color', [0.56 0.74 0.56]),...
        crystalSymmetry('m-3m', [2.9 2.9 2.9], 'mineral', 'Iron bcc (old)', 'color', [0.85 0.65 0.13]),...
        crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'Iron fcc', 'color', [0.94 0.5 0.5])};
    
    % plotting convention
    setMTEXpref('xAxisDirection','west');
    setMTEXpref('zAxisDirection','outOfPlane');

    % which files to be imported
    fname = [pname file];

    % create an EBSD variable containing the data
    ebsd = EBSD.load(fname,CS,'interface','ctf',...
        'convertEuler2SpatialReferenceFrame');

    [grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree);

    ebsd(grains(grains.grainSize<=5)) = [];
    [grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',10*degree,'removeQuadruplePoiints');
    
    grains = grains.smooth(5);
    
    newMtexFigure('figSize','large')
    plot(grains.boundary, 'linewidth', 2);
    exportgraphics(gcf,'gbs.png','Resolution',300);  
