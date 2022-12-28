%% distBetweenLL
% Perry Hong
% 22 Dec 2022
%
% Evaluates the distance (m) between two LL coordinate points 
% Assumes WGS84 spheroid
% t = latitude in degrees
% Uses average of latitude between the two points (mostly works as long as not too far apart in latitude, or close to equator)
% 1 deg latitude = 111132.92 - 559.82 cos(2t) + 1.175 cos(4t) - 0.0023 cos(6t) meters
% 1 deg longitude = 111412.84 cos (t) - 93.5 cos (3t) + 0.118 cos (5t) meters
% 
% === INPUT ===
% coordinates1: matrix [lat long] [N x 2]
% coordinates2: matrix [lat long] [1 x 2] or [N x 2]
%
% === OUTPUT ===
% distOut: distance in m [N x 2]

%% Begin function
function distOut = distBetweenLL(coordinates1, coordinates2)

    lat1 = coordinates1(:,1);
    long1 = coordinates1(:,2);
    lat2 = coordinates2(:,1);
    long2 = coordinates2(:,2);
    
    averageLatRad = deg2rad((lat1 + lat2)/2);

    latScale = 111132.92 - 559.82*cos(2*averageLatRad) + 1.175*cos(4*averageLatRad) - 0.0023*cos(6*averageLatRad);
    longScale = 111412.84*cos(averageLatRad) - 93.5*cos(3*averageLatRad) + 0.118*cos(5*averageLatRad);
    
    latDist = abs(lat1 - lat2).*latScale;
    longDist = abs(long1 - long2).*longScale;
    
    distOut = sqrt(latDist.^2 + longDist.^2);
    
end
