 python3 infra/helper.py build_fuzzers --sanitizer coverage libjpeg-turbo
 python3 infra/helper.py coverage libjpeg-turbo --corpus-dir build/out/corpus_with_initial_seeds --fuzz-target compress_fuzzer
