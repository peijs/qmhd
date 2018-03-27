## Analyzing the load on the system at the moment

CPU, Memory, Disk consumption analysis

```bash
splincode@mivanov:~/system-monitor$ ./shell/sys.sh # watch mode
[INFO] You did not specify the file name with the first arguments
[INFO] create logfile: /home/splincode/system-monitor/shell/tsv/mivanov.tsv
=======================
15:42:08 30.08.2017 	 CPU USAGE: 1.94% 	 MEMORY USAGE: 19.08% 	 DISK USAGE: 14%
```

```bash
# result 
$ cat shell/tsv/mivanov.tsv
CPU(%)	RAM(%)	DISK(%)
2.00	21.02	14
2.00	21.07	14
2.00	21.07	14
2.00	21.07	14
2.00	21.07	14
2.00	21.06	14
2.00	21.06	14
2.00	21.06	14
2.00	21.09	14
2.00	21.09	14
2.00	21.09	14
2.00	21.10	14
```

### Recommendation
```bash
$ chmod +x shell/sys.sh
```

### Vusialization
- load .tsv file to https://datacopia.com/#/Data

![](https://habrastorage.org/web/e24/c1d/567/e24c1d567d5f47dabf1d0d496cd4ff78.png)

- open google docs excel / microsoft excel

### TODO
- [x] Measuring the CPU
- [x] Measuring Memory Usage
- [x] Definition of disk space
- [x] Generation tsv
