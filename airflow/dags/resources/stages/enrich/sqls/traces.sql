SELECT
    transactions.`hash` as transaction_hash,
    traces.transaction_index,
    traces.from_address,
    traces.to_address,
    traces.value,
    traces.input,
    traces.output,
    traces.trace_type,
    traces.call_type,
    traces.reward_type,
    traces.gas,
    traces.gas_used,
    traces.subtraces,
    traces.trace_address,
    traces.error,
    traces.status,
    traces.trace_id,
    TIMESTAMP_SECONDS(blocks.timestamp) AS block_timestamp,
    blocks.number AS block_number,
    blocks.hash AS block_hash
FROM {{params.dataset_name_raw}}.blocks{{params.ds_postfix}} AS blocks
    JOIN {{params.dataset_name_raw}}.traces{{params.ds_postfix}} AS traces ON blocks.number = traces.block_number
    JOIN {{params.dataset_name_raw}}.transactions{{params.ds_postfix}} AS transactions
        ON traces.transaction_index = transactions.transaction_index
            and traces.block_number = transactions.block_number
where true
    {% if not params.load_all_partitions %}
    and date(timestamp_seconds(blocks.timestamp)) = '{{ds}}'
    {% endif %}



