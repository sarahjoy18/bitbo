<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;

class ChildExport implements FromCollection, WithHeadings, WithEvents, ShouldAutoSize
{

		use RegistersEventListeners;

	/**
    * @return \array
    */
    public function registerEvents():array{
    	$styleArray = [
            'alignment' => [
               'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
            ],         
			'font' => [
				'bold' => true,
                'size' => 12,
			],

		];

    	return[

            BeforeSheet::class=>function(BeforeSheet $event) use ($styleArray){
                $event->sheet->setCellValue('A1', 'BITBO - Health Services Newborn')
                ->mergeCells('A1:AB1')
                ->getStyle('A1:AB1')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b7e280')
                ;
            },

    		AfterSheet::class => function(AfterSheet $event) use ($styleArray) {
    			$event->sheet->getStyle('A2:D2')
                ->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('f5db6a')
                ;

                $event->sheet->getStyle('E2:G2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('248112');

                 $event->sheet->getStyle('H2:I2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('aacce8');

                 $event->sheet->getStyle('J2:AB2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('248112');


                $event->sheet->setCellValue('F'. ($event->sheet->getHighestRow('F')+2), 'Total # Infant received Vaccination');
                $event->sheet->setCellValue('G'. ($event->sheet->getHighestRow('G')+2), '=COUNTIF(G2:G'.$event->sheet->getHighestRow('G').',"✓")');
                $event->sheet->setCellValue('H'. ($event->sheet->getHighestRow('H')+2), '=COUNTIF(H2:H'.$event->sheet->getHighestRow('H').',"✓")');
                $event->sheet->setCellValue('I'. ($event->sheet->getHighestRow('I')+2), '=COUNTIF(I2:I'.$event->sheet->getHighestRow('I').',"✓")');
                $event->sheet->setCellValue('J'. ($event->sheet->getHighestRow('J')+2), '=COUNTIF(J2:J'.$event->sheet->getHighestRow('J').',"✓")');
                $event->sheet->setCellValue('K'. ($event->sheet->getHighestRow('K')+2), '=COUNTIF(K2:K'.$event->sheet->getHighestRow('K').',"✓")');
                $event->sheet->setCellValue('L'. ($event->sheet->getHighestRow('L')+2), '=COUNTIF(L2:L'.$event->sheet->getHighestRow('L').',"✓")');
                $event->sheet->setCellValue('M'. ($event->sheet->getHighestRow('M')+2), '=COUNTIF(M2:M'.$event->sheet->getHighestRow('M').',"✓")');
                $event->sheet->setCellValue('N'. ($event->sheet->getHighestRow('N')+2), '=COUNTIF(N2:N'.$event->sheet->getHighestRow('N').',"✓")');
                $event->sheet->setCellValue('O'. ($event->sheet->getHighestRow('O')+2), '=COUNTIF(O2:O'.$event->sheet->getHighestRow('O').',"✓")');
                $event->sheet->setCellValue('P'. ($event->sheet->getHighestRow('P')+2), '=COUNTIF(P2:P'.$event->sheet->getHighestRow('P').',"✓")');
                $event->sheet->setCellValue('Q'. ($event->sheet->getHighestRow('Q')+2), '=COUNTIF(Q2:Q'.$event->sheet->getHighestRow('Q').',"✓")');
                $event->sheet->setCellValue('R'. ($event->sheet->getHighestRow('R')+2), '=COUNTIF(R2:R'.$event->sheet->getHighestRow('R').',"✓")');
                $event->sheet->setCellValue('S'. ($event->sheet->getHighestRow('S')+2), '=COUNTIF(S2:S'.$event->sheet->getHighestRow('S').',"✓")');
                $event->sheet->setCellValue('T'. ($event->sheet->getHighestRow('T')+2), '=COUNTIF(T2:T'.$event->sheet->getHighestRow('T').',"✓")');
                $event->sheet->setCellValue('U'. ($event->sheet->getHighestRow('U')+2), '=COUNTIF(U2:U'.$event->sheet->getHighestRow('U').',"✓")');
                $event->sheet->setCellValue('Y'. ($event->sheet->getHighestRow('Y')+2), '=COUNTIF(Y2:Y'.$event->sheet->getHighestRow('Y').',"✓")');
                $event->sheet->setCellValue('Z'. ($event->sheet->getHighestRow('Z')+2), '=COUNTIF(Z2:Z'.$event->sheet->getHighestRow('Z').',"✓")');
                $event->sheet->getStyle('F'.$event->sheet->getHighestRow('F'))->applyFromArray($styleArray);
                $event->sheet->getStyle('G'.$event->sheet->getHighestRow('G'))->applyFromArray($styleArray);
                $event->sheet->getStyle('H'.$event->sheet->getHighestRow('H'))->applyFromArray($styleArray);
                $event->sheet->getStyle('I'.$event->sheet->getHighestRow('I'))->applyFromArray($styleArray);
                $event->sheet->getStyle('J'.$event->sheet->getHighestRow('J'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('K'.$event->sheet->getHighestRow('K'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('M'.$event->sheet->getHighestRow('M'))->applyFromArray($styleArray);
                $event->sheet->getStyle('N'.$event->sheet->getHighestRow('N'))->applyFromArray($styleArray);
                $event->sheet->getStyle('O'.$event->sheet->getHighestRow('O'))->applyFromArray($styleArray);
                $event->sheet->getStyle('P'.$event->sheet->getHighestRow('P'))->applyFromArray($styleArray);
                $event->sheet->getStyle('Q'.$event->sheet->getHighestRow('Q'))->applyFromArray($styleArray);
                $event->sheet->getStyle('R'.$event->sheet->getHighestRow('R'))->applyFromArray($styleArray);
                $event->sheet->getStyle('S'.$event->sheet->getHighestRow('S'))->applyFromArray($styleArray);
                $event->sheet->getStyle('T'.$event->sheet->getHighestRow('T'))->applyFromArray($styleArray);
                $event->sheet->getStyle('U'.$event->sheet->getHighestRow('U'))->applyFromArray($styleArray);
                $event->sheet->getStyle('Y'.$event->sheet->getHighestRow('Y'))->applyFromArray($styleArray);
                $event->sheet->getStyle('Z'.$event->sheet->getHighestRow('Z'))->applyFromArray($styleArray);
    		},
    	];
    	
    }

    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
          $child = collect(DB::select('
          	SELECT 
                CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
                ,H.HOUSEHOLD_ID
                ,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
                ,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
                ,DATE_OF_BIRTH
				,C.TYPE_OF_HOME_RECORD
				,IF (NB.HAD_BCG=1, "✓", "✗") AS BCG
				,IF (NB.HAD_HEPA_B=1, "✓", "✗") AS HEPA_B
				,IF (I.HAD_PENTA_1=1, "✓", "✗") AS PENTA_1
				,IF (I.HAD_PENTA_2=1, "✓", "✗") AS PENTA_2
				,IF (I.HAD_PENTA_3=1, "✓", "✗") AS PENTA_3
				,IF (I.HAD_OPV_1=1, "✓", "✗") AS OPV_1
				,IF (I.HAD_OPV_2=1, "✓", "✗") AS OPV_2
				,IF (I.HAD_OPV_3=1, "✓", "✗") AS OPV_3
				,IF (I.HAD_ROTA_1=1, "✓", "✗") AS ROTA_1
				,IF (I.HAD_ROTA_2=1, "✓", "✗") AS ROTA_2
				,IF (I.HAD_MEASLES=1, "✓", "✗") AS MEASLES
				,IF (I.HAD_VITAMIN_A=1, "✓", "✗") AS VITAMIN_A
				,IF (C.HAD_DEWORMING=1, "✓", "✗") AS DEWORMING
				,IF (C.HAD_MMR_12_15_MO=1, "✓", "✗") AS MMR_12_15_MOS
				,IF (C.HAD_VITAMIN_A_12_59_MO=1, "✓", "✗") AS VITAMIN_A_12_59_MOS
				,C.OPT_DATE
				,C.OPT_WEIGHT
				,C.OPT_HEIGHT
				,IF (C.GP_APRIL_DEWORMING=1, "✓", "✗") AS APRIL_DEWORMING
				,IF (C.GP_OCTOBER_DEWORMING=1, "✓", "✗") AS OCTOBER_DEWORMING
				,CONCAT(IF(C.DO_A=1,"A",""), IF(C.DO_B=1,"B",""), IF(C.DO_C=1,"C","")
				)AS DANGERS_OBSERVED
				,C.SOURCE_OF_SERVICE_RESERVED
            from t_hs_newborn AS NB
            INNER JOIN t_resident_basic_info as R
            ON R.RESIDENT_ID = NB.RESIDENT_ID
            INNER JOIN t_household_information AS H
            ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
			INNER JOIN t_hs_infant AS I
			ON I.NEW_BORN_ID = NB.NEWBORN_ID
			INNER JOIN t_hs_child AS C
			ON C.INFANT_ID = I.INFANT_ID

        	        	'));

        return $child;
    }

            /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		'Pangalan ng Bata'
			,'HH #'
			,'Edad'
			,'Petsa ng Kapanganakan'
			,'Klase ng Home-Based Record na mayroon ng UNINFANT'
			,'Nabigyan ng BGC?'
			,'Nabigyan ng Hepa B?'
			,'Nabigyan ng Penta 1?'
			,'Nabigyan ng Penta 2?'
			,'Nabigyan ng Penta 3?'
			,'Nabigyan ng Penta OPV 1?'
			,'Nabigyan ng Penta OPV 2?'
			,'Nabigyan ng Penta OPV 3?'
			,'Nabigyan ng Penta Rota 1?'
			,'Nabigyan ng Penta Rota 2?'
			,'Nabigyan ng Measles?'
			,'Nabigyan ng Vitamin A (6-11 mos.)?'
			,'Nabigyan ng Deworming?'
			,'Nabigyan ng MMR (12-15 mos.)?'
			,'Nabigyan ng Vitamin A (12-59 mos)?'
			,'OPT Date (12-71 mos)'
			,'OPT Timbang (kg)'
			,'OPT Haba/Tass (cm)'
			,'GP-Vit A (Abril)'
			,'GP-Vit A (Oktubre)'
			,'Panganib na naobserbahan'
			,'Pinanggalingan ng Serbisyong Natanggap'
    	];
    }
}
