#include<iostream>
#include "file_manager.h"
#include "errors.h"
#include<cstring>

#include <bits/stdc++.h>

using namespace std;

void insert(FileHandler &fh, string s, int d, int rl, int pl){

	vector<int> v;
	string s1 = "";
	for(int i=0; i<s.length(); i++){
		if(s[i] == ' '){
			v.push_back(stoi(s1));
			s1 = "";
		}
		else{
			s1 += s[i];
		}
	}

}


int main(int argc, char const *argv[]) {
	FileManager fm;

    ifstream input;
    input.open(argv[1]);

	int d = stoi(argv[2]);

	int rl = (PAGE_CONTENT_SIZE-12)/(4*(2*d+1));
	int pl = (PAGE_CONTENT_SIZE-12)/(4*(d+1));

	FileHandler fh = fm.CreateFile("temp.txt");

	while(!input.eof())
	{
		string line;
		getline(input,line);
		if(!line.empty()){
			switch (line[0])
			{
			case 'I':
				insert(fh,line);
				break;
			case 'P':
			case 'R':
			default:
				continue;
			}
		}
	}

	input.close();

	// // Create a new page
	// PageHandler ph = fh.NewPage ();
	// char *data = ph.GetData ();

	// // Store an integer at the very first location
	// int num = 5;
	// memcpy (&data[0], &num, sizeof(int));

	// // Store an integer at the second location
	// num = 1000;
	// memcpy (&data[4], &num, sizeof(int));

	// // Flush the page
	// fh.FlushPages ();
	// cout << "Data written and flushed" << endl;

	// // Close the file
	// fm.CloseFile(fh);

	// // Reopen the same file, but for reading this time
	// fh = fm.OpenFile ("temp.txt");
	// cout << "File opened" << endl;

	// // Get the very first page and its data
	// ph = fh.FirstPage ();
	// data = ph.GetData ();

	// // Output the first integer
	// memcpy (&num, &data[0], sizeof(int));
	// cout << "First number: " << num << endl;

	// // Output the second integer
	// memcpy (&num, &data[4], sizeof(int));
	// cout << "Second number: " << num << endl;

	// Close the file and destory it
	fm.CloseFile (fh);
	fm.DestroyFile ("temp.txt");
}
