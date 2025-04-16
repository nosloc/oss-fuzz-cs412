# Notes

## Run script for running with initial corpus

1. Make the run scripts to run with the initial corpus
   - The target is compress_fuzzer that fuzz the compress method of the library
   - ```python3 infra/helper.py build_image libjpeg-turbo``` Create the docker image for the fuzzer container  
    The dockerfile clone the fuzz dir of libjpeg-turbo on the image and the corpus seed used to fuzz
   - ```python3 infra/helper.py build_fuzzers libjpeg-turbo libjpeg-turbo --clean``` Create the container to run the different fuzzers  
    Compile all the files and generate the initial corpus for all the fuzzer in oss-fuzz/build/out/libjpeg-turbo
   - ```mkdir build/out/corpus_with_initial_seeds``` Create the directory to retreive the newly discovered seeds
   - ```python3 infra/helper.py run_fuzzer libjpeg-turbo compress_fuzzer --corpus-dir build/out/corpus_with_initial_seeds``` runs the compress_fuzzer and output the corpus in out/corpus_with_initial_seeds

   **Verify that the corpus is actually used in the INFOs before the actual start of the fuzzer**

   ```shell
   INFO: Running with entropic power schedule (0xFF, 100).
    INFO: Seed: 2963686110
    INFO: Loaded 1 modules   (15177 inline 8-bit counters): 15177 [0x560e0e3e0180, 0x560e0e3e3cc9), 
    INFO: Loaded 1 PC tables (15177 PCs): 15177 [0x560e0e3e3cd0,0x560e0e41f160), 
    INFO:     1984 files found in /tmp/compress_fuzzer_corpus
    INFO: -max_len is not provided; libFuzzer will not generate inputs larger than 202955 bytes
    INFO: seed corpus: files: 1984 min: 2b max: 202955b total: 5156856b rss: 35Mb
    ```

    Especially this line : ```INFO:     1984 files found in /tmp/compress_fuzzer_corpus```
2. Once stopped the output corpus can be found here **oss-fuzz/build/out/corpus_with_initial_seeds**  
   Listing the dir should output something like this :  

   ```shell
   $ ls oss-fuzz/build/out/corpus_with_initial_seeds                                                                  
008e3a8b37716aede8de29f850bf5be4ce7754b3 5ab02c611fce01f763474eb413838f9470e69718 aa9b3a90ead36a3bd8c628805c378bde3a608583
01035190a738591339061bc5d8c19fb94190256e 5b039df9350fd371eb8b0948aeeeb9a3497a705c aaf48d2e5584503f460ccf6cdc5fe1aeb4c8a43d
018626d731e2e1a888ce0a6f57bb5308a1a63412 5b440702e7c74a635273e53f39dbd644844ada43 ac4c21495cb79f59ba41dffe70528a32c291d979
01c78ee19dd7990afe944660a172be9e1172496a 5c02c81168d6ac0e3b07d4fd1759175d9f6b916d aca32dda661d5c74acde8605ec9b201118ef0d53
02816bf123c48687253a780f53fa08411d89beb7 5e2d76d3d7ac39294113d1915bc3a8fa2bf0a24b ad7e1acaf9bc48ed9e12da4efd6af26d0724f5e6
0464b8d77d760eb7395029cecca1498bece867b8 5f3f63be8886d138a5aa1c085b6bc0554c7c2787 afl-testcases
050e94cb17bd40926edac199f961c9e625af6aea 60a51b257af53e2ed1555e3b64ac21393c7b5dc0 b0b99633fa12e35f3e863b9cac80b663e5f0a153
051388983f2065b92fca60d6bba999e9faaca9e1 60f3f6bbacdd3e27919ee21e0d12fd8d54131eb7 b13c6bb7352355646b936be2f9b0d4379734bbbb
051aa718d1e2dd4b388c71a6756ee9dd7defdc77 623271876806049f5e8ce0e161f43d4f46133740 b15bfd678dae8f266b67d009e9889025b710cea3
```

3. Can generate the report using those two commands : or the ```create_coverage_with_initial_corpus.sh``` 

   ```sh
    python3 infra/helper.py build_fuzzers --sanitizer coverage libjpeg-turbo
    python3 infra/helper.py coverage libjpeg-turbo --corpus-dir build/out/corpus_with_initial_seeds --fuzz-target compress_fuzzer

    ```

4. The output of the report is place in oss-fuzz/build/out/libjpeg-turbo/report/linux/index.html
