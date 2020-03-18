<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBusinessNature
 * 
 * @property int $BUSINESS_NATURE_ID
 * @property string $BUSINESS_NATURE_NAME
 * @property string $BUSINESS_NATURE_DESCRIPTION
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_business_informations
 *
 * @package App\Models
 */
class RBusinessNature extends Eloquent
{
	protected $table = 'r_business_nature';
	protected $primaryKey = 'BUSINESS_NATURE_ID';
	public $timestamps = false;

	protected $casts = [
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BUSINESS_NATURE_NAME',
		'BUSINESS_NATURE_DESCRIPTION',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_business_informations()
	{
		return $this->hasMany(\App\Models\TBusinessInformation::class, 'BUSINESS_NATURE_ID');
	}
}
