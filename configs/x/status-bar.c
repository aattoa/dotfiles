#include <signal.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <unistd.h>
#include <X11/Xlib.h>

#ifdef __GNUC__
#define GNU_ATTRIBUTE(...) __attribute__((__VA_ARGS__))
#else
#define GNU_ATTRIBUTE(...)
#endif

static void die(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

GNU_ATTRIBUTE(format(scanf, 2, 3))
static int scan_file(const char *path, const char *fmt, ...) {
    FILE *stream = fopen(path, "r");
    if (stream == NULL) return -1;
    va_list args;
    va_start(args, fmt);
    int n = vfscanf(stream, fmt, args);
    va_end(args);
    fclose(stream);
    return n;
}

static uintmax_t read_statistic(uintmax_t *old, const char *path) {
    uintmax_t new;
    if (scan_file(path, "%ju", &new) != 1) die(path);
    uintmax_t delta = new - *old;
    *old = new;
    return new == delta ? 0 : delta;
}

static int ram_percentage(void) {
    uintmax_t total, free, available, buffers, cached;
    int n = scan_file("/proc/meminfo",
        "MemTotal:       %ju kB\n"
        "MemFree:        %ju kB\n"
        "MemAvailable:   %ju kB\n"
        "Buffers:        %ju kB\n"
        "Cached:         %ju kB\n",
        &total, &free, &available, &buffers, &cached);
    if (n != 5) die("Could not scan meminfo");
    return (total - free - buffers - cached) * 100 / total;
}

static size_t read_stream(char *out, size_t max, FILE *stream) {
    size_t n = 0;
    for (; n + 1 < max; ++n) {
        int c = fgetc(stream);
        if (c == EOF || c == '\n' || c == '\r') {
            break;
        }
        *out++ = c;
    }
    *out = 0;
    return n;
}

static size_t read_file(char *out, size_t max, const char *path) {
    FILE *stream = fopen(path, "r");
    if (stream == NULL) return 0;
    size_t n = read_stream(out, max, stream);
    fclose(stream);
    return n;
}

static size_t read_pipe(char *out, size_t max, const char *command) {
    FILE *stream = popen(command, "r");
    if (stream == NULL) return 0;
    size_t n = read_stream(out, max, stream);
    pclose(stream);
    return n;
}

static size_t print_bytes(char *out, size_t max, uintmax_t bytes) {
    if (bytes < 1024) {
        return snprintf(out, max, "%ju B", bytes);
    }
    uintmax_t kibibytes = bytes / 1024;
    bytes %= 1024;
    if (kibibytes < 1024) {
        return snprintf(out, max, "%ju.%ju KiB", kibibytes, bytes / 100);
    }
    uintmax_t mebibytes = kibibytes / 1024;
    kibibytes %= 1024;
    return snprintf(out, max, "%ju.%ju MiB", mebibytes, kibibytes / 100);
}

static const char *battery_status(void) {
    FILE *status = fopen("/sys/class/power_supply/BAT0/status", "r");
    if (status != NULL) {
        int c = fgetc(status);
        fclose(status);
        // See linux/drivers/power/supply/power_supply_sysfs.c
        if (c == 'F') return "";  // Full
        if (c == 'C') return "+"; // Charging
        if (c == 'D') return "-"; // Discharging
        if (c == 'N') return "="; // Not charging
    }
    return "?";
}

static const char *volume_cmd =
    "/usr/bin/amixer get Master | /usr/bin/tail -1 | /usr/bin/awk -F \"[][]\" '/%/ { print $2 \" \" $4 }'";

static void format_status(char *buf, size_t len) {
    static uintmax_t rx = 0, tx = 0;
    time_t t = time(NULL);
    size_t n = 0;

    n +=    snprintf(buf + n, len - n, "Down ");
    n += print_bytes(buf + n, len - n, read_statistic(&rx, "/sys/class/net/wlp4s0/statistics/rx_bytes"));
    n +=    snprintf(buf + n, len - n, "/s | Up ");
    n += print_bytes(buf + n, len - n, read_statistic(&tx, "/sys/class/net/wlp4s0/statistics/tx_bytes"));
    n +=    snprintf(buf + n, len - n, "/s | RAM %i%% | Vol ", ram_percentage());
    n +=   read_pipe(buf + n, len - n, volume_cmd);
    n +=    snprintf(buf + n, len - n, " | Bat ");
    n +=   read_file(buf + n, len - n, "/sys/class/power_supply/BAT0/capacity");
    n +=    snprintf(buf + n, len - n, "%%%s | ", battery_status());
    n +=    strftime(buf + n, len - n, "%a %F %T", localtime(&t));
}

static sig_atomic_t keep_running = 1;

static void stop_running(int signal) {
    (void)signal;
    keep_running = 0;
}

static void ignore_signal(int signal) {
    (void)signal;
}

int main(void) {
    signal(SIGINT, stop_running);
    signal(SIGTERM, stop_running);
    signal(SIGUSR1, ignore_signal);

    Display *display = XOpenDisplay(NULL);
    if (display == NULL) {
        die("Could not open X display");
    }

    Window window = DefaultRootWindow(display);
    char buffer[1024];

    while (keep_running) {
        format_status(buffer, sizeof buffer);
        XStoreName(display, window, buffer);
        XFlush(display);
        sleep(1);
    }

    XCloseDisplay(display);
}
