# template_paper_review
A markdown template for a scientific review paper

## Getting Started

### Prerequisites
- [LuaTex](https://miktex.org/)
- [Pandoc](https://github.com/jgm/pandoc/releases/)
- [pandoc-crossref](https://github.com/lierdakil/pandoc-crossref/releases)
- ([zotero](https://www.zotero.org/))

### Installing
1. Install Igor Pro 6.1 or later.
2. Put GlobalProcedure.ipf of tUtility or its shortcut into the Igor Procedures folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Procedures.
3. SetWindowExt.xop or its shortcut into the Igor Extensions folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Extensions.
4. Optional: SetWindowExt Help.ipf or its shortcut into the Igor Help Files folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Help Files.
5. Put tSort.ipf or its shortcut into the Igor Procedure folder.
6. Restart Igor Pro.

### How to initialize the tSort GUI
* Click "tSortInitialize" in "Initialize" submenu of "tSort" menu.
* Main control panel (tSortMainControlPanel), main graph (tSortMainGraph), event graph (tSortEventGraph), master table (tSortMasterTable), and slave table (tSortSlabeTable) windows will appear.

### How to use
#### Spike detection and sorting
1. Get your waves into the List on "Main" tab of the main control panel using "GetAll" or "GetWL" buttons. The names of source waves on the list can directly be edited by cliking "EditList" button. Spike, LFP, ECoG, EMG, and Marker fields supporse to have high-pass filterd waves, low-pass filterd waves, LFP of another brain region, EMG, and TTL signal for stimulation. The list must have at least waves in the Spike field.
2. Set parameters for spike detection in "Extract" tab of the main control panel.
3. Set a source wave for analysis by clicking "srcWave" button on the Main tab of the main control panel.
4. Make the master table and the main graph ready for spike detection by clicking "MTablePrep" and then "DisplayInit" buttons on the Main tab.
5. Detect spikes on the source wave by clicking "AutoSearch" button on the Main tab.
6. Calculate several parameters associated with spikes (interevent intervals etc.) by clicking "EachParam" button on the Main tab.
7. Move on the next sweep (wave) by clicking "Next Sw" button on the panel of the main graph.
8. Repeat 5 to 7 over your all waves on the list.
9. Extract waveforms of all events by clicking "Extract" button of the event graph.
10. Do principle component analysis and get the first three figures for each spike by clicking "PCA" button on the Cluster tab of the main control panel.
11. Do clustering by clicking "FPC" button in Minimum group on the Cluster tab.
12. Calculate indexed interevent intervals and pattern index by clicking "IndexedIEI" and "PatternIndex" buttons on the master table.
13. Sort each unit whether burst or non-burst by clicking "BurstIndex" button on the panel of the main graph.

## References
- Takeuchi Y\*, Nagy AJ, Barcsai L, Li Q, Ohsawa M, Mizuseki K, Berényi A\*, The medial septum as a potential target for treating brain disorders associated with oscillopathies. Front Neural Circuits, in press. 14 Jun 2021. DOI: https://doi.org/10.3389/fncir.2021.701080
