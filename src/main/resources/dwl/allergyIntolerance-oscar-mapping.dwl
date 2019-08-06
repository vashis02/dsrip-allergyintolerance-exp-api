%dw 2.0
output application/json  
---
if (payload.status == 204)
  payload
else
  {
    resourceType: "Bundle",
    "type": "searchset",
    meta: {
      lastUpdated: now()
    },
    entry: payload map (payload01, indexOfPayload01) -> {
      fullUrl: "https://apiconnect-dev.mountsinai.org/api/AllergyIntolerance/" ++ indexOfPayload01,
      resource: {
        resourceType: "AllergyIntolerance",
        patient: {
          reference: "MEDICAL_RECORD_NUMBER/" ++ payload01."MEDICAL_RECORD_NUMBER"
        },
        identifier: [
          {
            assigner: {
              display: payload01."DATA_SOURCE_NAME"
            }
          }
        ],
        "type": "allergy",
        category: ["medication"],
        verificationStatus: "unconfirmed",
        code: {
          coding: [
            {
              display: payload01."ALLERGEN_NAME"
            }
          ],
          text: payload01."ALLERGEN_NAME"
        },
        recorder: {
          display: payload01."ENTERED_BY"
        },
        clinicalStatus: 
          if (payload01.STATUS == "DELETED" or payload01.STATUS == "DEL")
            "resolved"
          else (if (payload01.STATUS == "INACTIVE")
            "inactive"
          else
            "active"),
        criticality: 
          if ((payload01.SEVERITY == "5" or payload01.SEVERITY == "3" or payload01.SEVERITY == "-1"))
            "high"
          else (if (payload01.SEVERITY == "7")
            "low"
          else
            "unable-to-assess"),
        note: [
          {
            text: payload01."REACTION_COMMENT"
          }
        ]
      }
    }
  }