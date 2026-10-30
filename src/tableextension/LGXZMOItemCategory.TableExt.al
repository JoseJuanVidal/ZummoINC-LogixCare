tableextension 50018 "LGX ZMO Item Category" extends "Item Category" //5722
{
    fields
    {
        field(50000; "LGX ZMO Sales Count"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Count';
            ObsoleteState = Removed;
            ObsoleteReason = 'Wrong data type';
        }
    }
}