<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsChild
 * 
 * @property int $CHILD_ID
 * @property string $TYPE_OF_HOME_RECORD
 * @property string $DANGERS_OBSERVED
 * @property string $SOURCE_OF_SERVICE_RESERVED
 * @property int $HAD_DEWORMING
 * @property int $HAD_MMR_12_15_MO
 * @property int $HAD_VITAMIN_A_12_59_MO
 * @property \Carbon\Carbon $OPT_DATE
 * @property string $OPT_WEIGHT
 * @property string $OPT_HEIGHT
 * @property int $GP_APRIL_DEWORMING
 * @property int $GP_OCTOBER_DEWORMING
 * @property int $DO_A
 * @property int $DO_B
 * @property int $DO_C
 * @property int $INFANT_ID
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\THsInfant $t_hs_infant
 *
 * @package App\Models
 */
class THsChild extends Eloquent
{
	protected $table = 't_hs_child';
	protected $primaryKey = 'CHILD_ID';
	public $timestamps = false;

	protected $casts = [
		'HAD_DEWORMING' => 'int',
		'HAD_MMR_12_15_MO' => 'int',
		'HAD_VITAMIN_A_12_59_MO' => 'int',
		'GP_APRIL_DEWORMING' => 'int',
		'GP_OCTOBER_DEWORMING' => 'int',
		'DO_A' => 'int',
		'DO_B' => 'int',
		'DO_C' => 'int',
		'INFANT_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'OPT_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'TYPE_OF_HOME_RECORD',
		'DANGERS_OBSERVED',
		'SOURCE_OF_SERVICE_RESERVED',
		'HAD_DEWORMING',
		'HAD_MMR_12_15_MO',
		'HAD_VITAMIN_A_12_59_MO',
		'OPT_DATE',
		'OPT_WEIGHT',
		'OPT_HEIGHT',
		'GP_APRIL_DEWORMING',
		'GP_OCTOBER_DEWORMING',
		'DO_A',
		'DO_B',
		'DO_C',
		'INFANT_ID',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_hs_infant()
	{
		return $this->belongsTo(\App\Models\THsInfant::class, 'INFANT_ID');
	}
}
