# Portable echo shell function

Portable `echo` shell function for POSIX compliant shells. It works exactly the same in all shells.

## Functions

* `puts` - Output as is without interpreting escape sequences and options.
* `putsn` - `puts` with newline.
* `echo` - Overwrite built-in `echo`. Only supported `-n` option.

## Solved the problem

### Problem

```sh
echo -e "\e[31m RED \e[m"
```

| Shell    | Output                          | Shell           | Output                       |
| -------- | ------------------------------- | --------------- | ---------------------------- |
| **dash** | -e <font color="red">RED</font> | **mksh**        | <font color="red">RED</font> |
| **bash** | <font color="red">RED</font>    | **yash**        | -e \e[31mRED\e[m             |
| **zsh**  | <font color="red">RED</font>    | **posh**        | -e \e[31mRED\e[m             |
| **ksh**  | \e[31mRED\e[m                   | **busybox ash** | <font color="red">RED</font> |

### Portable echo shell function

```sh
echo -e "\e[31m RED \e[m"
```

| Shell    | Output             | Shell           | Output             |
| -------- | ------------------ | --------------- | ------------------ |
| **dash** | -e \e[31m RED \e[m | **mksh**        | -e \e[31m RED \e[m |
| **bash** | -e \e[31m RED \e[m | **yash**        | -e \e[31m RED \e[m |
| **zsh**  | -e \e[31m RED \e[m | **posh**        | -e \e[31m RED \e[m |
| **ksh**  | -e \e[31m RED \e[m | **busybox ash** | -e \e[31m RED \e[m |

How to output with color.

```sh
ESC=$(printf '\033')
echo "${ESC}[31m RED ${ESC}[m"
```

| Shell    | Output                       | Shell           | Output                       |
| -------- | ---------------------------- | --------------- | ---------------------------- |
| **dash** | <font color="red">RED</font> | **mksh**        | <font color="red">RED</font> |
| **bash** | <font color="red">RED</font> | **yash**        | <font color="red">RED</font> |
| **zsh**  | <font color="red">RED</font> | **posh**        | <font color="red">RED</font> |
| **ksh**  | <font color="red">RED</font> | **busybox ash** | <font color="red">RED</font> |
