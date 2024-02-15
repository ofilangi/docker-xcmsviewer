# docker-xcmsviewer

## build image

```bash
docker build . -t test
```

## preprocessing data

- 1) put all mzXML files into extdata
- 2) create a `group` inside to assign a group condition to a mzXML file

example : `extdata/group`

```tsv
23_0234.mzXML   A  
23_0245.mzXML   A
```


```bash
docker run -p 3838:3838 -v $(pwd)/extdata:/extdata -t test xcmsViewer_preprocess.R
```

## visualizing data data

```bash
docker run -p 3838:3838 -v $(pwd)/extdata:/extdata -t test xcmsViewer.R
```

Default values : 
- `PORT "3838"`
- `HOST "0.0.0.0"`
- `TRACE "FALSE"`

possibility to override all env variables

```bash
docker run --env TRACE="TRUE"  -p 3838:3838 -v $(pwd)/extdata:/extdata -t test xcmsViewer.R
```


