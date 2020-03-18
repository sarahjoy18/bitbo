<?php

namespace App\Exports;
use App\Models\TRESIDENTBASICINFO;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithTitle;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;

class ResidentsPerMonth implements FromQuery, WithHeadings, WithEvents, WithTitle
{
    // private $month;
    // private $year;

    // public function __construct(int $year, int $month)
    // {
    //     $this->month = $month;
    //     $this->year  = $year;
    // }
    use RegistersEventListeners;

    public function registerEvents(): array
    {
        $styleArray = [
            'font' => [
                'bold' => true,
            ]
        ];

        return [

             // Handle by a closure.
            BeforeSheet::class => function(BeforeSheet $event) use ($styleArray) {

                $event->sheet->setCellValue('A1','BARANGAY PROFILING INFORMATION SYSTEM');

            },
            // Handle by a closure.
            AfterSheet::class => function(AfterSheet $event) use ($styleArray) {
                
                 $event->sheet->insertNewRowBefore(1, 1);
                 $event->sheet->insertNewRowBefore('A3', 1);
                 $event->sheet->getStyle("A1:D1")->applyFromArray($styleArray);
                // $event->sheet->setCellValue('COLUMNHERE', '=SUM(COLUMNHERE:COLUMNHERE)');
            },
        ];
    }

       // // Array callable, refering to a static method.
            // BeforeWriting::class => [self::class, 'beforeWriting'],
             //$event->writer->getProperties()->setCreator('Patrick');
            // // Using a class with an __invoke method.
            // BeforeSheet::class => new BeforeSheetHandler()
    /**
     * @return Builder
     */
    public function query()
    {
        return TRESIDENTBASICINFO::ALL();
        //return TRESIDENTBASICINFO::query()->where('ACTIVE_FLAG',1);
        // ->whereYear('created_at', $this->year)
        // ->whereMonth('created_at', $this->month);
    }

    /**
     * @return string
     */
    public function title(): string
    {
        // return 'Month ' . $this->month;
        return 'Month';
    }

    public function headings(): array
    {
     // return [
     //     'FIRSTNAME',
     //     'MIDDLENAME',
     //     'LASTNAME',
     //     'DATE_OF_BIRTH',
     // ];
    }

}