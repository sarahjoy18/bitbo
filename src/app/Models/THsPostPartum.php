<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsPostPartum
 * 
 * @property int $POST_PATRUM_ID
 * @property int $PREGNANT_ID
 * @property string $BIRTH_PLACE
 * @property string $BIRTH_COORDINATOR
 * @property string $DANGERS_OBSERVED
 * @property int $IS_FP_USER
 * @property int $INTERESTED_IN_FP
 * @property int $SOURCE_OF_SERVICE_RECEIVED
 * @property \Carbon\Carbon $BIRH_DATE
 * @property int $HAD_BREASTFEED_1_HR
 * @property int $HAD_POSTNATAL_24_HRS
 * @property int $HAD_POSTNATAL_72_HRS
 * @property int $HAD_POSTNATAL_7_DAYS
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\THsPregnant $t_hs_pregnant
 *
 * @package App\Models
 */
class THsPostPartum extends Eloquent
{
	protected $table = 't_hs_post_partum';
	protected $primaryKey = 'POST_PATRUM_ID';
	public $timestamps = false;

	protected $casts = [
		'PREGNANT_ID' => 'int',
		'IS_FP_USER' => 'int',
		'INTERESTED_IN_FP' => 'int',
		'SOURCE_OF_SERVICE_RECEIVED' => 'int',
		'HAD_BREASTFEED_1_HR' => 'int',
		'HAD_POSTNATAL_24_HRS' => 'int',
		'HAD_POSTNATAL_72_HRS' => 'int',
		'HAD_POSTNATAL_7_DAYS' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'BIRH_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'PREGNANT_ID',
		'BIRTH_PLACE',
		'BIRTH_COORDINATOR',
		'DANGERS_OBSERVED',
		'IS_FP_USER',
		'INTERESTED_IN_FP',
		'SOURCE_OF_SERVICE_RECEIVED',
		'BIRH_DATE',
		'HAD_BREASTFEED_1_HR',
		'HAD_POSTNATAL_24_HRS',
		'HAD_POSTNATAL_72_HRS',
		'HAD_POSTNATAL_7_DAYS',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_hs_pregnant()
	{
		return $this->belongsTo(\App\Models\THsPregnant::class, 'PREGNANT_ID');
	}
}
