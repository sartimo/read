#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// Function to download a URL using libcurl
size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    size_t written = fwrite(ptr, size, nmemb, stream);
    return written;
}

// Function to download a file from a URL and save it to a specified path
int downloadFile(const char* url, const char* outputPath) {
    CURL *curl;
    FILE *outputFile;

    curl = curl_easy_init();
    if (!curl) {
        fprintf(stderr, "Error initializing libcurl.\n");
        return 1;
    }

    outputFile = fopen(outputPath, "wb");
    if (!outputFile) {
        fprintf(stderr, "Error opening output file for writing.\n");
        curl_easy_cleanup(curl);
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, NULL);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, outputFile);

    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        fclose(outputFile);
        curl_easy_cleanup(curl);
        return 1;
    }

    fclose(outputFile);
    curl_easy_cleanup(curl);

    printf("Downloaded file from %s to %s\n", url, outputPath);
    return 0;
}

int main() {
    // default 
    const char* url = "https://example.com/rcfile.rc";
  
    FILE *rcFile = fopen("links.rc", "r");
    if (rcFile == NULL) {
        printf("Error: Cannot open links.rc file.\n");
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
    rcFile = fopen("links.rc", "r");
    if (rcFile == NULL) {
        printf("Error: Cannot open links.rc file.\n");
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
