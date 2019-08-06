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
        patient: {
          reference: "MEDICAL_RECORD_NUMBER/" ++ payload01."MEDICAL_RECORD_NUMBER"
        },
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
        assertedDate: 
          if (not payload01."ENTRY_DATE" == null)
            payload01."ENTRY_DATE" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "yyyy-MM-dd"}
          else
            "",
        clinicalStatus: 
          if (payload01.STATUS == "DELETED")
            "resolved"
          else (if (payload01.STATUS == "ACTIVE")
            "active"
          else
            "active"),
        criticality: 
          if (payload01.SEVERITY == 5)
            "high"
          else (if (payload01.SEVERITY == 7)
            "low"
          else (if (payload01.SEVERITY == 3)
            "high"
          else
            "unable-to-assess")),
        note: [
          {
            text: payload01."REACTION_COMMENT"
          }
        ]
      }
    }
  }