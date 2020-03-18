<?php

namespace App\Exports;

use App\Models\TUser;
use App\Models\TRESIDENTBASICINFO;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithMultipleSheets;
use Maatwebsite\Excel\Concerns\Exportable;

use Maatwebsite\Excel\Concerns\WithTitle;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
//class ResidentsExport implements FromQuery, WithMapping, WithHeadings, WithColumnFormatting, WithMultipleSheets
class ResidentsExport implements FromQuery, WithHeadings, WithEvents, ShouldAutoSize
{
    use Exportable;

  
    /**
    * @return \Illuminate\Support\Collection
    */

      use RegistersEventListeners;

    public function registerEvents(): array
    {


        $styleArray = [

                'alignment' => [
                'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
            ],    
            'font' => [
                'bold' => true,
                'size' => 12,
            ]
        ];

        return [

            BeforeSheet::class => function(BeforeSheet $event) use ($styleArray){
                $event->sheet->setCellValue('A1', 'BITBO - Residents Information And Household Information')
                ->mergeCells('A1:AB1')
                ->getStyle('A1:BA1')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('aacce8');
               
                
            },

            AfterSheet::class => function(AfterSheet $event) use ($styleArray) {
                
                // $event->sheet->getStyle('A5:A51')->getAlignment()->applyFromArray(
                //     array('horizontal' => 'center')
                // );
                
                 $event->sheet->insertNewRowBefore(1, 1);

                 $event->sheet->getStyle("A3:BA3")->applyFromArray($styleArray);
                 $event->sheet->insertNewRowBefore(1, 1);
                
            },
        ];
    }

    public function query()
    {
      
      $result = \DB::TABLE('T_RESIDENT_BASIC_INFO AS T')
                ->JOIN('T_HOUSEHOLD_INFORMATION AS H','T.HOUSEHOLD_ID','H.HOUSEHOLD_ID')
                ->JOIN('R_RESIDENT_TYPE AS RT','T.ARRIVAL_STATUS','TYPE_ID')
                ->SELECT(\DB::RAW(
                        "
                        T.LASTNAME,
                        T.FIRSTNAME,
                        IFNULL(T.MIDDLENAME,''),
                        IFNULL(T.ADDRESS_UNIT_NO,''),
                        IFNULL(T.ADDRESS_PHASE,''),
                        IFNULL(T.ADDRESS_HOUSE_NO,''),
                        IFNULL(T.ADDRESS_STREET,''),
                        IFNULL(T.QUALIFIER,''),
                        IFNULL(T.DATE_OF_BIRTH,''),
                        IFNULL(T.PLACE_OF_BIRTH,''),
                        IFNULL(T.SEX,''),
                        IFNULL(T.CIVIL_STATUS,''),
                        IF(T.IS_OFW = 1,'Y', 'N') AS IS_OFW,
                        IFNULL(T.OCCUPATION,''),
                        IFNULL(T.WORK_STATUS,''),
                        IFNULL(T.DATE_STARTED_WORKING,''),
                        IFNULL(T.CITIZENSHIP,''),
                        IFNULL(T.RELATION_TO_HOUSEHOLD_HEAD,''),
                        IFNULL(T.DATE_OF_ARRIVAL,''),
                        RT.TYPE_NAME,
                        IF(T.IS_INDIGENOUS = 1,'Y', 'N') AS IS_INDIGENOUS,
                        IFNULL(T.CONTACT_NUMBER,'NO CONTACT NUMBER'),
                        IFNULL(T.EDUCATIONAL_ATTAINMENT,''),

                        IFNULL(H.HOME_OWNERSHIP,''),
                        IFNULL(H.PERSON_STAYING_IN_HOUSEHOLD,''),
                        IFNULL(H.HOME_MATERIALS,''),
                       
                        IFNULL(H.NUMBER_OF_ROOMS,''),

                        IF(H.TOILET_HOME = 1,'Y', 'N') AS TOILET_HOME,
                        IF(H.PLAY_AREA_HOME = 1,'Y', 'N') AS PLAY_AREA_HOME,
                        IF(H.BEDROOM_HOME = 1,'Y', 'N') AS BEDROOM_HOME,
                        IF(H.DINING_ROOM_HOME = 1,'Y', 'N') AS DINING_ROOM_HOME,
                        IF(H.SALA_HOME = 1,'Y', 'N') AS SALA_HOME,
                        IF(H.KITCHEN_HOME = 1,'Y', 'N') AS KITCHEN_HOME,
                        IF(H.WATER_UTILITIES = 1,'Y', 'N') AS WATER_UTILITIES,
                        IF(H.ELECTRICITY_UTILITIES = 1,'Y', 'N') AS ELECTRICITY_UTILITIES,
                        IF(H.AIRCON_UTILITIES = 1,'Y', 'N') AS AIRCON_UTILITIES,
                        IF(H.PHONE_UTILITIES = 1,'Y', 'N') AS PHONE_UTILITIES,
                        IF(H.COMPUTER_UTILITIES = 1,'Y', 'N') AS COMPUTER_UTILITIES,
                        IF(H.INTERNET_UTILITIES = 1,'Y', 'N') AS INTERNET_UTILITIES,
                        IF(H.TV_UTILITIES = 1,'Y', 'N') AS TV_UTILITIES,
                        IF(H.CD_PLAYER_UTILITIES = 1,'Y', 'N') AS CD_PLAYER_UTILITIES,
                        IF(H.RADIO_UTILITIES = 1,'Y', 'N') AS RADIO_UTILITIES,
                        IF(H.COMICS_ENTERTAINMENT = 1,'Y', 'N') AS COMICS_ENTERTAINMENT,
                        IF(H.NEWS_PAPER_ENTERTAINMENT = 1,'Y', 'N') AS NEWS_PAPER_ENTERTAINMENT,
                        IF(H.PETS_ENTERTAINMENT = 1,'Y', 'N') AS PETS_ENTERTAINMENT,
                        IF(H.BOOKS_ENTERTAINMENT = 1,'Y', 'N') AS BOOKS_ENTERTAINMENT,
                        IF(H.STORY_BOOKS_ENTERTAINMENT = 1,'Y', 'N') AS STORY_BOOKS_ENTERTAINMENT,
                        IF(H.TOYS_ENTERTAINMENT = 1,'Y', 'N') AS TOYS_ENTERTAINMENT,
                        IF(H.BOARD_GAMES_ENTERTAINMENT = 1,'Y', 'N') AS BOARD_GAMES_ENTERTAINMENT,
                        IF(H.PUZZLES_ENTERTAINMENT = 1,'Y', 'N') AS PUZZLES_ENTERTAINMENT

                        "
                    ))
                ->ORDERBY('T.HOUSEHOLD_ID');
              // DD($RES);
        return $result;
       
       //return \DB::RAW("SELECT HOUSEHOLD_ID, LASTNAME, FIRSTNAME, MIDDLENAME FROM T_RESIDENT_BASIC_INFO");
    }

   

    public function headings(): array
    {
        return [
            
            'LASTNAME',
            'FIRSTNAME',
            'MIDDLENAME',
            'ADDRESS UNIT NO',
            'ADDRESS PHASE',
            'ADDRESS HOUSE_NO',
            'ADDRESS STREET',
            'QUALIFIER',
            'DATE OF BIRTH (YYYY--MM--DD)',
            'PLACE OF BIRTH',
            'SEX',
            'CIVIL STATUS',
            'IS OFW (Y/N)',
            'OCCUPATION',
            'WORK STATUS',
            'DATE STARTED WORKING',
            'CITIZENSHIP',
            'RELATION TO HOUSEHOLD_HEAD',
            'DATE OF ARRIVAL (YYYY--MM--DD)',
            'ARRIVAL STATUS (NR FOR NATIVE RESIDENTS), (M FOR MIGRANTS)',
            'IS INDIGENOUS (Y/N)',
            'CONTACT NUMBER',
            'EDUCATIONAL ATTAINMENT',


            'HOME OWNERSHIP',
            'PERSON STAYING IN HOUSEHOLD',
            'HOME MATERIALS',
            'NUMBER OF ROOMS',
             
            'TOILET HOME (Y/N)',
            'PLAY AREA HOME (Y/N)',
            'BEDROOM HOME (Y/N)',
            'DINING ROOM HOME (Y/N)',
            'SALA HOME (Y/N)',
            'KITCHEN HOME (Y/N)',
            'WATER UTILITIES (Y/N)',
            'ELECTRICITY UTILITIES (Y/N)',
            'AIRCON UTILITIES (Y/N)',
            'PHONE UTILITIES (Y/N)',
            'COMPUTER UTILITIES (Y/N)',
            'INTERNET UTILITIES (Y/N)',
            'TV UTILITIES (Y/N)',
            'CD PLAYER UTILITIES (Y/N)',
            'RADIO ADDRESS (Y/N)',
            'COMICS ENTERTAINMENT (Y/N)',
            'NEW PAPER ENTERTAINMENT (Y/N)',
            'PETS ENTERTAINMENT (Y/N)',
            'BOOKS ENTERTAINMENT (Y/N)',
            'STORY BOOKS ENTERTAINMENT (Y/N)',
            'TOYS ENTERTAINMENT (Y/N)',
            'BOARD GAMES ENTERTAINMENT (Y/N)',
            'PUZZLES ENTERTAINMENT (Y/N)',
            'POSITION IN THE BARANGAY (LEAVE IT BLANK IF NOT A BARANGAY OFFICIAL)',
            'START TERM (YYYY--MM--DD)',
            'END TERM(YY--MM--DD)',
        ];
    }

  

}
