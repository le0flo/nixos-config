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
  char cmd[1024];
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

  printf("All children terminated, shutting down\n");

  free(jobs);
  exit(0);
}

int main(int argc, char **argv) {
  DIR *dir;
  struct dirent *entry;
  int i, j, pid, status;

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

    jobs[n_jobs].cmd[0] = '\0';

    strcat(jobs[n_jobs].cmd, argv[1]);
    if (argv[1][strlen(argv[1]) - 1] != '/') strcat(jobs[n_jobs].cmd, "/");
    strcat(jobs[n_jobs].cmd, entry->d_name);
    
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
  free(entry);
  closedir(dir);

  for (i=0; i<n_jobs; i++) {
    jobs[i].pid = fork();

    if (jobs[i].pid == 0) {
      execlp(jobs[i].cmd, "", NULL);
      exit(2);
    }
  }

  while (n_jobs > 0) {
    pid = wait(&status);
    printf("PID %d terminated with exit code %d\n", pid, status >> 8);

    if ((status >> 8) == 0) {
      for (j=0; j<n_jobs; j++) {
        if (jobs[j].pid == pid && jobs[j].terminated == 0) {
          jobs[j].pid = fork();

          if (jobs[j].pid == 0) {
            execlp(jobs[j].cmd, "", NULL);
            exit(2);
          }
          else {
            printf("Starting new job with PID %d\n", jobs[j].pid);
            break;
          }
        }
      }
    }
  }
  printf("No jobs found, shutting down\n");

  free(jobs);
  return 0;
}
