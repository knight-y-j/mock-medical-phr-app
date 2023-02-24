---
title: Trust
---

## Trust Architecture

-----

### Diagram

#### Actor

```mermaid
  flowchart LR
    id1(Patient) -- in hospital --> id2(Hospital)
    id2(Hospital) -- diagnosis --> id3(Doctor) -- trust diagnosis --> id1
    id3(Doctor) <-- trust diagnosis --> id4(Nurse)
    id1(Patient) -- Trust / Mint --> id5(Smart contract)
    id1(Patient) -- upload trust metadata --> id6(Storage)
    id3(Doctor) -- update trust metadata --> id6(Storage)
    id5(Smart contract) <-- NFT --> id7(Market place)

    id2(Hospital) -- trust datumn --> id5(Smart contract) 
```

#### In Hospital (Usecase)

##### Trust Occurrence

- Pattern

1. A: Upsert trust datumn to smart contract from Hospital Gateway
2. B: Upsert trust datumn to smart contract from HIS/EMR
   1. the term
      1. HIS(Hospital Information System)
      2. EMR(Electronic Medical Record)
3. C: Upsert trust datumn to smart contract from edge device

```mermaid
  flowchart LR
  subgraph NFT owner
  id1(Patient)
  end

  subgraph Hospital
  id2(Edge Device)
  id3(HIS/EMR)
  id4(Hospital Gateway)
  end

  subgraph Smart contract
  id5(Trust Contract)
  end

  id1(Patient) -- diagnosis --> id2(Edge Device)
  id2(Edge Device) -- Health record ? --> id3(HIS/EMR)
  id3(HIS/EMR) -- what upload ? --> id4(Hospital Gateway)
  id4(Hospital Gateway) -- A: Occurence trust --> id5(Trust Contract)

  id2(Edge Device) -- diagnostic Request --> id2(Edge Device)

  id3(HIS/EMR) -- B: Occurence trust --> id5(Trust Contract)
  id2(Edge Device) -- C: Occurence trust --> id5(Trust Contract)
```

##### Trust Approve

- Diagnostic request pattern

1. A: Diagnostic request to hospital Doctor from etc ?
2. B: Diagnostic request to hospital Doctor from Edge device

- show metadata (diagnosis) pattern

1. C: display metadata from HIS/EMR
2. D: display metadata from Storage

```mermaid
  flowchart LR

  subgraph Hospital
  id1(etc ?)
  id2(Doctor)
  id3(Nurse)
  id4(Edge Device)
  id5(HIS/EMR)
  end

  subgraph Smart contract
  id6(Contract)
  end

  subgraph IPFS
  id7(Storage)
  end

  id1(etc ?) -- A: diagnostic request --> id2(Doctor)
  id4(Edge Device) -- B: diagnostic request --> id2(Doctor)
  id2(Doctor) -- req check diagnosis --> id3(Nurse)
  id3(Nurse) -- res check diagnosis --> id2(Doctor)
  id2(Doctor) -- approve trust data --> id6(Contract)

  id2(Doctor) -- diagnosis --> id2(Doctor)

  id2(Doctor) -- D: req display metadata --> id7(Storage)
  id7(Storage) -- res display metadata --> id2(Doctor)

  id2(Doctor) -- C: req display metadata --> id5(HIS/EMR)
  id5(HIS/EMR) -- res display metadata --> id2(Doctor)
```

#### Trust Acknowledgement

- upload metadata(Health record) Pattern

1. A: upload metadata to HIS/EMR
2. B: upload metadata to Storage(IPFS)

```mermaid
  flowchart LR

  subgraph NFT owner
    id1(Patient)
  end

  subgraph Hospital
    id2(Edge Device)
    id3(Doctor)
    id4(Nurse)
    id6(HIS/EMR)
  end

  subgraph Smart contract
    id5(Trust contract)
  end

  subgraph IPFS
    id8(Storage)
  end

  id1(Patient) <-- Ack Acknowledgement --> id2(Edge Device)
  id2(Edge Device) -- res diagnosis Acknowledgement--> id3(Doctor)
  id3(Doctor) -- req diagnosis Acknowledgement--> id2(Edge Device)
  id3(Doctor) <-- display Acknowledgement --> id4(Nurse)

  id1(Patient) -- validate ackowledgement --> id1(Patient)

  id2(Edge Device) -- ackowledgement trust data --> id5(Trust contract)

  id2(Edge Device) -- update metadata --> id2(Edge Device)
  id2(Edge Device) -- A: upload metadata --> id6(HIS/EMR)
  id2(Edge Device) -- B: upload metadata --> id8(Storage)
```
