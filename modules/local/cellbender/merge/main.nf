process CELLBENDER_MERGE {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/cellbender:0.3.0--c4addb97ab2d83fe':
        'community.wave.seqera.io/library/cellbender:0.3.0--41318a055fc3aacb' }"

    input:
    tuple val(meta), path(filtered), path(raw), path(cellbender_h5)

    output:
    tuple val(meta), path("${prefix}.h5ad"), emit: h5ad
    path "versions.yml"                    , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: "${meta.id}"
    template 'merge.py'
}
