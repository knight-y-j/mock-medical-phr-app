---
title: ER diagram
---

## ER Diagram

- Trust ER diagram

-----

### Patient

- NFT owner

1. register patient
2. personal health record

- 

```mermaid
  erDiagram

  PATIENT {
    bool hasPatients 
  }
```

- HL7 FHIR

```mermaid
  erDiagram

  HEALTH_RECORD {
    object patient
  }
```
