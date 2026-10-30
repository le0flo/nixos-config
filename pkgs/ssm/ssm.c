#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <dirent.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>

#define USAGE "%s <PATH>\n", argv[0]
#define MAX_JOBS 256

struct job {
  char filename[256];
  int pid;
  int terminated;
};

struct job *jobs;
int n_jobs;

void terminator(int _) {
  printf("Received termination signal\n");

  for (int i=0; i<n_jobs; i++) {
    if (jobs[i].terminated == 1) continue;

    if (kill(jobs[i].pid, SIGTERM) == -1) {
      perror("Couldn't kill child");
      exit(1);
    }
  }

  printf("All children terminated\n");
}

int main(int argc, char **argv) {
  DIR *dir;
  struct dirent *entry;
  char *script;
  int i, j, script_len, add_sep, pid, status;

  if (signal(SIGINT, terminator) == SIG_ERR) {
    perror("Cannot assign SIGINT signal handler");
    exit(1);
  }

  if (signal(SIGTERM, terminator) == SIG_ERR) {
    perror("Cannot assign SIGTERM signal handler");
    exit(1);
  }
  
  if (argc != 2) {
    fprintf(stderr, USAGE);
    exit(1);
  }

  dir = opendir(argv[1]);
  if (dir == NULL) {
    perror("Cannot open the given directory");
    exit(1);
  }

  n_jobs = 0;
  jobs = malloc(sizeof(struct job) * MAX_JOBS);
  if (jobs == NULL) {
    fprintf(stderr, "Cannot allocated enough space for the job struct\n");
    closedir(dir);
    exit(1);
  }

  errno = 0;
  while ((entry = readdir(dir)) != NULL) {
    if (entry->d_type != DT_REG) continue;
    if (strcmp(entry->d_name + (strlen(entry->d_name) - 3), ".sh") != 0) continue;

    if (strcpy(jobs[n_jobs].filename, entry->d_name) == NULL) {
      fprintf(stderr, "Couldn't copy the filename\n");
      free(jobs);
      closedir(dir);
      exit(1);
    };

    jobs[n_jobs].pid = 0;
    jobs[n_jobs].terminated = 0;
    n_jobs++;
  }
  if (errno != 0) {
    perror("Occured while reading a directory entry");
    free(jobs);
    closedir(dir);
    exit(1);
  }
  closedir(dir);

  script_len = strlen(argv[1]);
  add_sep = 0;
  if (argv[1][script_len - 1] != '/') {
    script_len++;
    add_sep = 1;
  }

  for (i=0; i<n_jobs; i++) {
    jobs[i].pid = fork();

    if (jobs[i].pid == 0) {
      script_len += strlen(jobs[i].filename) + 1;
      script = malloc(sizeof(char) * script_len);
      script[0] = '\0';

      strcat(script, argv[1]);
      if (add_sep == 1) strcat(script, "/");
      strcat(script, jobs[i].filename);

      printf("PID %d is running the following command: %s\n", getpid(), script);

      execlp(script, "", NULL);
      exit(2);
    }
  }

  status = 0;
  for (i=0; i<n_jobs; i++) {
    pid = wait(&status);
    printf("PID %d terminated with exit code %d\n", pid, status >> 8);

    for (j=0; j<n_jobs; j++) {
      if (jobs[j].pid == pid) {
        jobs[j].terminated = 1;
      }
    }
  }

  free(jobs);
  return 0;
}
