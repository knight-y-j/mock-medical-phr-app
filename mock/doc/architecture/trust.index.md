---
title: Trust
---

## Trust Architecture

-----

### Diagram

- In hospital

```mermaid
  flowchart LR
    id1(Patient) -- in hospital --> id2(Hospital)
    id2(Hospital) -- diagnosis --> id3(Doctor) -- outcome --> id1
    id3(Doctor) -- act --> id4(Nurse) -- act --> id3
```

- System architecture

```mermaid
  flowchart LR
  id1(Edge Device) -- transaction --> id2(Hospital Gateway) -- response --> id1
  id2(Hospital Gateway)
```
