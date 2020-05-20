#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id = "about-section", style="min-height: 800px",
             tags$div(class="section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-12',
                               h1("About Us", 
                                  style="color: white; text-align:center; font-family: 'Roboto Slab', serif;")
                      )
             ),
             tags$div(class='row',style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-6',
                               tags$div(class="info-card", style="min-height: 400px",
                                        tags$div(class="row", style='background-color: #82A9D0; margin: 0px 0px 0px 0px;',
                                                 h3("Who Are we?",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 p("The Adult ECMO program at WVU Medicine – the only one of its kind in the state – is a nationally recognized Center of Excellence, providing the highest level of care and outcomes.",
                                                   style="font-size: 20px"
                                                 ),
                                                 br(),
                                                 p("The WVU Heart and Vascular Institute was recognized with the ELSO Center of Excellence Silver Life Support Award from the Extracorporeal Life Support Organization (ELSO) which recognizes those centers that demonstrate an exceptional commitment to evidence-based processes and quality measures, staff training and continuing education, patient satisfaction, and ongoing clinical care.",
                                                   style="font-size: 20px"
                                                   )
                                        )
                               )
                               ),
                      tags$div(class='col-sm-6',
                               tags$div(class="info-card", style="min-height: 400px",
                                        tags$div(class="row", style='background-color: #82A9D0; margin: 0px 0px 0px 0px;',
                                                 h3("What is Extra-Corporeal Membrane Oxygenation (ECMO)?",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 p("ECMO (Extra-Corporeal Membrane Oxygenation) is a life-support machine used in patients with life-threatening heart and/or breathing problems. When the heart does not pump enough blood or the lungs do not provide enough oxygen, ECMO can be used to assist the heart and/or lungs while giving the body a chance to rest.",
                                                   style="font-size: 20px"
                                                 )
                                        )
                               )
                               )
                      ),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-6',
                               tags$div(class="info-card", style="min-height: 405px",
                                        tags$div(class="row", style='background-color: #FF9E01; margin: 0px 0px 0px 0px;',
                                                 h3("About the WVU Medicine Adult ECMO Care Team",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 p("The ECMO Air Response Transport Team is a group of specially trained surgeons, perfusionists, nurses, and specialists, who are able to transport critically ill patients. The team’s specially equipped aircraft includes a portable ECMO machine and other advanced equipment. The team can mobilize within two hours of transfer request and is on call 24 hours a day, seven days a week. It has an accessible range of 119 nautical miles.",
                                                   style="font-size: 20px"
                                                 ),
                                                 br(),
                                                 p("The WVU Medicine ECMO Ground Team remains available throughout the transfer process, helping manage real-time information while the ECMO Air Response Transport Team is en route",
                                                   style="font-size: 20px"
                                                   )
                                        )
                               )
                               ),
                      tags$div(class='col-sm-6',
                               tags$div(class="info-card", style="min-height: 405px",
                                        tags$div(class="row", style='background-color: #FF9E01; margin: 0px 0px 0px 0px;',
                                                 h3("Adult ECMO Referral Process",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 p("Timing is critical, and it is important to know when ECMO is the right option for your patient. Any patient with severe hypoxia despite 100% oxygen is a candidate.",
                                                   style="font-size: 20px"
                                                 ),
                                                 br(),
                                                 p("To arrange for patient transfer to our ECMO Program, call the Medical Access Referral System at 800-WVA-MARS (800-982-6277).",
                                                   style="font-size: 20px; font-weight: 900;"
                                                   ),
                                                 br(),
                                                 p("Specialized cardiothoracic surgeons trained in advanced respiratory failure and ECMO will quickly obtain a thorough history and offer management guidance in consultation with your team. The ECMO team rapidly evaluates the case to determine candidacy for ECMO or potential transfer without ECMO, when appropriate. If accepted, our access transfer team will send you a checklist to help prepare the patient for transfer while our mobile ECMO transport team is deployed to your hospital.",
                                                   style="font-size: 20px"
                                                   )
                                        )
                               )
                               )
                      )
             )
  )
}
    
#' landing Server Function
#'
#' @noRd 
mod_about_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_landing_ui("landing_ui_1")
    
## To be copied in the server
# callModule(mod_landing_server, "landing_ui_1")
 
