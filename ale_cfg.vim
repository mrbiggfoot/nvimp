let g:ale_linters = {'cpp': ['clang']}
let g:ale_cpp_clang_executable = '/opt/cross/clang-3.8.1/bin/clang++'
let g:ale_cpp_clang_options = '
\ -fsyntax-only
\ -fvisibility-inlines-hidden
\ -xc++
\ -Wall
\ -Wextra
\ -Werror
\ -Wno-enum-compare
\ -Wno-ignored-qualifiers
\ -Wno-unused-parameter
\ -march=nehalem
\ -mtune=haswell
\ -D_GNU_SOURCE
\ -D__STDC_FORMAT_MACROS
\ -DARENA_LSAN_LEVEL=1
\ -DFUNCTION_REFLECTION
\ -Wno-invalid-offsetof
\ -std=c++14
\ -gcc-toolchain /opt/cross/el7.3-x86_64/gcc-4.9.4
\ -B /opt/cross/el7.3-x86_64/gcc-4.9.4/bin
\ -target x86_64-redhat-linux
\ --sysroot /opt/cross/el7.3-x86_64/sysroot
\ -Qunused-arguments
\ -Wno-deprecated-register
\ -Wno-unused-local-typedef
\ -ftemplate-depth=512
\ -isystem /home/andrew/projects/main/build
\ -isystem /home/andrew/projects/main/build/toolchain/include
\ -I /home/andrew/projects/main
\ '
