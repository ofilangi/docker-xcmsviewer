# docker-xcmsviewer

## Build Image

```bash
docker build -t xcmsViewer .
```

## Preprocessing Data

- Create `extdata` directory: `mkdir extdata`
- Put mzXML files into `extdata`
- Create a `group` file to assign group conditions

Example: `extdata/group`

```tsv
23_0234.mzXML   A  
23_0245.mzXML   A
```

```bash
docker run -p 3838:3838 -v $(pwd)/extdata:/extdata -t xcmsViewer xcmsViewer_preprocess.R
```
## Visualizing Data
```bash
docker run -p 3838:3838 -v $(pwd)/extdata:/extdata -t xcmsViewer xcmsViewer.R
```
Default values:
- `PORT "3838"`
- `HOST "0.0.0.0"`
- `TRACE "FALSE"`

Override env variables:

```bash
docker run --env TRACE="TRUE" -p 3838:3838 -v $(pwd)/extdata:/extdata -t xcmsViewer xcmsViewer.R
```
