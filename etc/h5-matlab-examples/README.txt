

This folder contains the MATLAB(R) equivalent code for the C API examples given in the link below.
    http://www.hdfgroup.org/ftp/HDF5/examples/examples-by-api/api18-c.html


Things to keep in mind when using the MATLAB(R) interface:
----------------------------------------------------------


1. The MATLAB(R) interface to HDF 5 library functions is split into classes based on the API groups. A specific API should be accessed through its corresponding group class using the '.' operator.

    Example:

    /* C code */
    status = H5Fclose (file);

    % M code
    H5F.close (file);


2. Use strings and/or calls to H5ML.get_constant_value instead of named constants.

    Example:

    /* C code */
    file = H5Fcreate (fileName, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);

    % M code
    file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');


3. Use output arguments in place of pointer arguments used to return values in the C API.

    Example:

    /* C code */
    hsize_t         dims[2] = {DIM0, DIM1},
    ...
    ndims = H5Sget_simple_extent_dims (space, dims, NULL);

    % M code    
    [ndims dims] = H5S.get_simple_extent_dims(space);

4. MATLAB(R) uses column-major indexing while the HDF 5 library routines are row-major.

    Example:

    If a variable wdata had the following value in MATLAB(R):

    wdata =

           1           3           5
           2           4           6

    and was written to an HDF 5 file using the following syntax:
    
    file = H5F.create ('sample.h5', 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
    space = H5S.create_simple (2,[2 3], []);
    dset = H5D.create (file, DATASET, 'H5T_STD_I64BE', space, 'H5P_DEFAULT');
    H5D.write (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);

    The column-major indexing of the above array would appear to the HDF 5 library to have the following order ( 1 2 3 4 5 6). The library interprets this as a 2x3 row-major array, resulting in the data being stored as below:

    DATA {
    (0,0): 1, 2, 3,
    (1,0): 4, 5, 6

    Flipping the dimensions using the following call to H5S.create:

    space = H5S.create_simple (2,fliplr([2 3]), []);

    would result in the data being stored as below (a transpose of the data as seen in MATLAB(R)):
 
    DATA {
    (0,0): 1, 2,
    (1,0): 3, 4,
    (2,0): 5, 6
    }

    The examples in this directory flip the dimensions, hence the data stored in the HDF 5 file will be the transpose of that shown in the C API examples.
    
    The flipping of dimensions can be ignored if the data is expected to be written and read from MATLAB(R) code. However, care must be taken if the data is to be interpreted by non-MATLAB(R) applications. 

    A useful hint to identify functions wherein the dimension issue needs to be addressed, is to look at the function signature in the help text. The appropriate variables will be prefixed with 'h5_' as shown below:
         output = H5S.create_simple(rank, h5_dims, h5_maxdims)

5. MATLAB(R) uses 1-based indexing while the HDF 5 library routines are 0-based. The indices passed to the library routine must be given in 0-based format.

    Example:

    /* C code */
    start[0]  = 0;
    start[1]  = 0;
    stride[0] = 3;
    stride[1] = 3;
    count[0]  = 2;
    count[1]  = 3;
    block[0]  = 2;
    block[1]  = 2;
    status = H5Sselect_hyperslab (space, H5S_SELECT_SET, start, stride, count,block);    

    % M code
    start(1)  = 0;
    start(2)  = 0;
    stride(1) = 3;
    stride(2) = 3;
    count(1)  = 2;
    count(2)  = 3;
    block(1)  = 2;
    block(2)  = 2;
    H5S.select_hyperslab (space, 'H5S_SELECT_SET', fliplr(start), fliplr(stride), fliplr(count), fliplr(block));

6. To obtain more knowledge on any HDf 5 library API, invoke help on the corresponding MATLAB(R) interface.

    Example:

    % To obtain information on the equivalent for the C API H5Sget_simple_extent_dims
    % use the following M code
    help H5S.get_simple_extent_dims


7. The example code is mainly used to illustrate the use of the MATLAB(R) interface to the HDF 5 library. While certain parts of the code leverage MATLAB(R)'s features, the M code is written as closely as possible to the C code. A user can always explore other avenues to make the code simpler and efficient in MATLAB (For example, using DISP to display arrays instead of FPRINTF).