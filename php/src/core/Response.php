<?php

namespace Guaroj;

class Response
{
    protected static $instance;

    public static function getInstance()
    {
        if (is_null(static::$instance)) {
            static::$instance = Container::getInstance()->get(Response::class);
        }

        return static::$instance;
    }


    public function execute(array $data): void
    {
        $payload=[];
        $payload["message"] = $data ? "OK" : "ERROR";
        
        foreach($data as $rec) {
            if(!isset($payload["labels"])) {
                $payload["labels"] = array_keys($rec);
            }
            $payload["data"][]=array_values($rec);
        }

        echo json_encode($payload, JSON_UNESCAPED_UNICODE);
        exit(0);
    }



}
