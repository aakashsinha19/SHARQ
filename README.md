# SHARQ
Implementing SHARQ protocols in openLTE and study performance variation with Maximum HARQ rounds.

## Objectives

Minimize HARQ re-transmission delay.
Reduce Block-Error Rate.
Dynamically decide node-of-retransmission.
Co-operative communication.

## Why do we need HARQ?

To attain system level improvement in throughput, HARQ needs to be designed for cooperative relays.

HARQ protocol with incremental redundancy has been proven to provide strong robustness against multipath fading channel. 

For a distributed system of cooperative relays, the HARQ protocol is expected to significantly improve the end-to-end performance.

## Cooperative Scheme

Delay Diversity Scheme
Attains diversity gain by introducing frequency selectivity.
Distributed Alamouti Scheme
Reference signal of one relay orthogonal to the reference signal of other relay within the same set of subcarriers. In this way, they will have a zero cross-correlation.

## SHARQ

The cooperative system of distributed relays establishes end-to-end link in two phases
Phase 1 being from source to relays.
Phase 2 is from relays to destination.

Phase 2 establishes the link even when just one relay decodes the signal. 
HARQ scheme should therefore be devised in a smart way which initiates retransmissions from source only when signal is decoded incorrectly at both the relays.

In phase 2 of cooperative system, error performance is expected to be better when both relays forward and exploit the macro-diversity. 
If the destination decodes the signal incorrectly
One is to have retransmission in phase 2.
Other is to have retransmission in phase 1 (if retransmissions in phase 1 are not exhausted).

## Proposed Implementation

Minimize interference using frequency selectivity.
Re-transmission from forwarding relay having the latest transmission timestamp.
Proposing HARQ rounds to reduce redundancy and creating a robust network.
Implementing dual-hop transmission network in openLTE.
