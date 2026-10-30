pageextension 50028 "LGX ZMO Item Categories" extends "Item Categories" //5730
{
    layout
    {
        addafter(Description)
        {
            field("Parent Category"; "Parent Category")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}