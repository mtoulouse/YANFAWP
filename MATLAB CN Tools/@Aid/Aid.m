classdef Aid < handle
%AID Foreign Aid Object.
%   AID represents a single aid transaction, storing the amount and time
%   aided, as well as the aid reason and status (approved, pending, etc.).
%   The sending and receiving nations are also stored as Nation objects.
     properties
         StatDateTaken % date data was gathered
         DateAided % date of aid
         Amount %structure w/ Money, Tech, Soldier fields
         Memo % string
         Sender % Nation object
         Receiver % Nation object
         Status  = 'UNKNOWN' % string (Approved, Pending, Expired, Canceled, UNKNOWN)
     end
     
     methods
         function AD = Aid()
             % constructor method
             AD.Amount.Money = 0;
             AD.Amount.Tech = 0;
             AD.Amount.Soldiers = 0;
         end
         
         function AL = RemoveExpired(AL)
             % removes all the non-approved or non-pending aid entries from
             % an array of Aid objects.
             ri = [];
             Q = strcmp(PropertyArray(AL,'Status'),'Expired');
             S = strcmp(PropertyArray(AL,'Status'),'Canceled');
             R = strcmp(PropertyArray(AL,'Status'),'UNKNOWN');
             for i = 1:length(AL)
                 if Q(i) || R(i) || S(i)
                     ri = [ri i];
                 end 
             end
             AL(ri) = [];
         end
     end
end