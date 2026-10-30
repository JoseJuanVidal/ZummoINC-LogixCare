report 50004 "LGX ZMO CFA Incident Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/LGXZMOCFAIncidentReport.Report.rdl';
    Caption = 'CFA Incident Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = LGXZMOFunctionality;

    dataset
    {
        dataitem("Service & Warranty Header"; "LGX ZMO Service & Warranty Hdr")
        {
            RequestFilterFields = "LGX ZMO Serial No.", "LGX ZMO Incident Date", "LGX ZMO Warranty", "LGX ZMO Sell-to Customer Name", "LGX ZMO Status";
            column(IncidentNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Incident No.")
            {
            }
            column(IncidentDate_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Incident Date")
            {
            }
            column(CloseDate_; CloseDate)
            {
            }
            column(SelltoCustomerName_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Sell-to Customer Name")
            {
            }
            column(Average_; Average)
            {
            }
            column(SerialNo_ServiceWarrantyHeader; "Service & Warranty Header"."LGX ZMO Serial No.")
            {
            }
            dataitem("Service & Warranty Comments"; "LGX ZMO Service Warr. Comment")
            {
                DataItemLink = "LGX ZMO No." = FIELD("LGX ZMO Incident No.");
                RequestFilterFields = "LGX ZMO Date";
                column(Date_ServiceWarrantyComments; "Service & Warranty Comments"."LGX ZMO Date")
                {
                }
                column(Comment_ServiceWarrantyComments; "Service & Warranty Comments"."LGX ZMO Comment")
                {
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    var
        CloseDate: Date;
        Average: Decimal;
}

