// Include your modules here


workflow {

    
    //Here we construct the initial channels we need
    
    Channel.fromPath(params.subsampled_samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

   


}