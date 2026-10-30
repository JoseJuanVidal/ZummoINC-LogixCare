pageextension 50001 "LGX ZMO Customer Card" extends "Customer Card" //21
{
    layout
    {

        addlast(General)
        {
            field(CRMId; CRMId)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'CRM Id';
                Visible = false;
            }
            field(SPCRMId; SPCRMId)
            {
                ApplicationArea = LGXZMOFunctionality;
                Caption = 'SP CRM Id';
                Visible = false;
            }
            field("LGX ZMO CESCE"; "LGX ZMO CESCE")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE No."; "LGX ZMO CESCE No.")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
            field("LGX ZMO CESCE Cr. Limit"; "LGX ZMO CESCE Cr. Limit")
            {
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }

    trigger OnOpenPage()
    var
        SalesPerson: record "Salesperson/Purchaser";
    begin
        SalesPerson.Reset();
        SalesPerson.SetRange("LGX ZMO SalesPerson User ID", UserId());
        SalesPerson.SetRange("LGX ZMO Set Cust. List Filter", true);
        if SalesPerson.FindFirst() then begin
            FILTERGROUP(2);
            SetRange("Salesperson Code", SalesPerson.Code);
            FILTERGROUP(0);
        end;
    end;

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMSalesperson: Record "Salesperson/Purchaser";
    begin
        // ANS - CRM Integration
        Clear(CRMId);
        Clear(SPCRMId);
        CRMIntegrationRecord.Reset();
        CRMIntegrationRecord.SetRange("Table ID", DATABASE::Customer);
        CRMIntegrationRecord.SetRange("Integration ID", Id);
        if CRMIntegrationRecord.FindFirst() then
            CRMId := CRMIntegrationRecord."CRM ID";

        if CRMSalesperson.GET("Salesperson Code") then
            if CRMIntegrationRecord.FindByRecordID(CRMSalesperson.RecordId()) then
                CRMIntegrationRecord.FindIDFromRecordID(CRMSalesperson.RecordId(), SPCRMId);
        // ANS - CRM Integration
    end;

    var
        CRMId: Guid;
        SPCRMId: Guid;
}