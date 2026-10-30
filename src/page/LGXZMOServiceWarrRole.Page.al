page 50005 "LGX ZMO Service & Warr. Role"
{
    Caption = 'Service & Warranty';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Activities)
            {
                part("Services & Warranty Activities"; "LGX ZMO Serv. & Warr. Act.")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
            group(List)
            {
                part("Services & Warranty List"; "LGX ZMO Serv. & Warranty List")
                {
                    ApplicationArea = LGXZMOFunctionality;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            ToolTip = 'Manage sales processes. See KPIs and your favourite items and customers.';
            action("Service & Warranty")
            {
                Image = Action;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "LGX ZMO Services & Warranty";
                ApplicationArea = LGXZMOFunctionality;
            }
        }
        area(embedding)
        {
            action("Service & Warranty List")
            {
                Image = Action;
                RunObject = Page "LGX ZMO Service & Warr. List";
                ApplicationArea = LGXZMOFunctionality;
            }
        }
    }
}

