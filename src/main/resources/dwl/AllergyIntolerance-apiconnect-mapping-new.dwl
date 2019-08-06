%dw 2.0
output application/json  skipNullOn="everywhere"
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
        id: payload01."PATIENT_ALLERGY_KEY",
        patient: {
          reference: "Patient/" ++ payload01."PATIENT_ID"
        },
        identifier: [
          {
            assigner: {
              display: payload01."SOURCE_PARTNER_NAME"
            }
          }
        ],
        code: {
          text: payload01."ALLERGEN_NAME",
          coding: [
            {
              display: payload01."ALLERGEN_NAME"
            }
          ]
        },
        "type": "allergy",
        category: "medication",
        clinicalStatus: 
          if (payload01.STATUS == "DELETED")
            "resolved"
          else
            "active",
        verificationStatus: "unconfirmed",
        criticality: 
          if (payload01.SEVERITY == "HIGH")
            "high"
          else (if (payload01.SEVERITY == "MEDIUM")
            "medium"
          else (if (payload01.SEVERITY == "LOW")
            "low"
          else
            "unable-to-assess"))
      }
    }
  }