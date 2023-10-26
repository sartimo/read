#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <curl/curl.h>

// function to fetch newest .librc file from registry
void update() {
    // Add functionality for option A here
    printf("Option A called.\n");
}

// function to check if file exists
int fileExists(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file) {
        fclose(file);
        return 1; // File exists
    }
    return 0; // File does not exist
}

// function to download a given file
int downloadFile(const char *url, const char *path) {
    CURL *curl = curl_easy_init();
    if (curl) {
        FILE *file = fopen(path, "wb");
        if (file) {
            curl_easy_setopt(curl, CURLOPT_URL, url);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);

            CURLcode res = curl_easy_perform(curl);
            fclose(file);

            if (res == CURLE_OK) {
                curl_easy_cleanup(curl);
                return 1; // Download successful
            }
        }
        curl_easy_cleanup(curl);
    }
    return 0; // Download failed
}

// Function to download a URL using libcurl
size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    size_t written = fwrite(ptr, size, nmemb, stream);
    return written;
}

int main(int argc, char *argv[]) {
    const char *url = "https://github.com/sartimo/lib/.librc";
    const char *path = ".librc";

    // check if rcfile exists
    if (fileExists(path)) {
        printf(".librc file founds: %s\n", path);
    } else {
        // download newest rcfile
        printf("couldn't find .librc file: %s\n", path);
        printf("fetching newest .librc file from registry...\n");

        if (downloadFile(url, path)) {
            printf("successfully fetched newest .librc file: %s saved as %s\n", url, path);
        } else {
            printf("download failed: %s\n", url);
        }
    }
    
    int opt;
    while ((opt = getopt(argc, argv, "abc:")) != -1) {
        switch (opt) {
            case 'update':
                update();
                break;
                exit(0);
            default:
                // default routine
                fprintf(stderr, "Usage: %s -update [argument]\n", argv[0]);

                FILE *rcFile = fopen(path, "r");
                if (rcFile == NULL) {
                    printf("error: Cannot open .librc file.\n");
                    return 1;
                }
            
                char line[256];
                int lineNum = 0;
            
                // Print and store links from the .rc file
                while (fgets(line, sizeof(line), rcFile)) {
                    lineNum++;
                    printf("%d. %s", lineNum, line);
                }
            
                fclose(rcFile);
            
                int choice;
                printf("\nEnter the number of the link to download: ");
                scanf("%d", &choice);
            
                // Re-open the file and navigate to the chosen link
                rcFile = fopen(path, "r");
                if (rcFile == NULL) {
                    printf("error: Cannot open .librc file.\n");
                    return 1;
                }
            
                int currentLine = 0;
                while (fgets(line, sizeof(line), rcFile)) {
                    currentLine++;
                    if (currentLine == choice) {
                        char link[256];
                        sscanf(line, "%*[^:]: %255s", link); // Extract the URL
                        CURL *curl = curl_easy_init();
                        if (curl) {
                            CURLcode res;
                            FILE *outfile = fopen("downloaded_file", "wb"); // You can change the filename here
                            curl_easy_setopt(curl, CURLOPT_URL, link);
                            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
                            curl_easy_setopt(curl, CURLOPT_WRITEDATA, outfile);
            
                            res = curl_easy_perform(curl);
            
                            if (res != CURLE_OK) {
                                fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
                            }
            
                            curl_easy_cleanup(curl);
                            fclose(outfile);
                        } else {
                            fprintf(stderr, "Error initializing libcurl.\n");
                        }
                        break;
                    }
                }
            
                fclose(rcFile);
                return 0;
                
        }
    }

    return 0;
}
